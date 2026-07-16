import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'country_service.dart';

class FlightService {
  final Dio _dio = Dio();
  final CountryService _countryService;

  final Map<String, Map<String, dynamic>> _airportDetailsCache = {};
  final Map<String, String?> _airlineNameCache = {};

  static final String _apiKey = dotenv.env["AIRLABS_KEY"]!;
  static const String _base = "https://airlabs.co/api/v9";

  FlightService({required CountryService countryService})
    : _countryService = countryService;

  Future<Response> _get(String path, {Map<String, dynamic>? params}) => _dio
      .get("$_base$path", queryParameters: {"api_key": _apiKey, ...?params});

  String _formatDate(DateTime dt) =>
      "${dt.day.toString().padLeft(2, '0')}/"
      "${dt.month.toString().padLeft(2, '0')}/"
      "${dt.year}";

  String _formatTime(DateTime dt) =>
      "${dt.hour.toString().padLeft(2, '0')}:"
      "${dt.minute.toString().padLeft(2, '0')}";

  String _buildFlightId({
    String? flightCode,
    required String origin,
    required String destination,
    String? date,
  }) {
    if (flightCode != null && flightCode.trim().isNotEmpty) {
      return flightCode.trim();
    }

    final sanitizedDate = (date ?? '').replaceAll(
      RegExp(r'[^A-Za-z0-9_]'),
      '_',
    );
    final sanitizedOrigin = origin.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
    final sanitizedDestination = destination.replaceAll(
      RegExp(r'[^A-Za-z0-9_]'),
      '_',
    );
    final base = '${sanitizedOrigin}_to_${sanitizedDestination}';
    if (sanitizedDate.isNotEmpty) {
      return '${base}_date_${sanitizedDate}'.replaceAll(RegExp(r'\s+'), '_');
    }
    return base.replaceAll(RegExp(r'\s+'), '_');
  }

  String _cityFromAirportName(String name) => name
      .replaceAll(
        RegExp(
          r'\s*(International|Intl\.?|Regional|Municipal|Airport|'
          r'Air\s+Base|Airfield|Aeropuerto|Aéroport|Flughafen|Aeroporto)\s*',
          caseSensitive: false,
        ),
        ' ',
      )
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  Future<String?> _getAirlineName(String iataCode) async {
    if (iataCode.isEmpty) return null;
    if (_airlineNameCache.containsKey(iataCode)) {
      return _airlineNameCache[iataCode];
    }
    try {
      final response = await _get("/airlines", params: {"iata_code": iataCode});
      final items = response.data["response"] as List? ?? [];
      if (items.isNotEmpty) {
        final name = items.first["name"]?.toString();
        _airlineNameCache[iataCode] = name;
        return name;
      }
    } catch (_) {}
    _airlineNameCache[iataCode] = null;
    return null;
  }

  Future<Map<String, dynamic>> getAirportDetails(String iata) async {
    final code = iata.toUpperCase();
    final cached = _airportDetailsCache[code];
    if (cached != null) return cached;

    final response = await _get("/airports", params: {"iata_code": code});
    final items = response.data["response"] as List? ?? [];
    if (items.isEmpty) throw Exception("Airport not found: $iata");

    final airport = items.first as Map;

    final rawCity =
        airport["city"]?.toString().trim() ??
        airport["city_name"]?.toString().trim() ??
        "";
    final airportName = airport["name"]?.toString().trim() ?? "";
    final cityName = rawCity.isNotEmpty
        ? rawCity
        : airportName.isNotEmpty
        ? _cityFromAirportName(airportName)
        : code;

    final countryCode = airport["country_code"]?.toString().trim() ?? "";
    final rawCountryName =
        airport["country_name"]?.toString().trim() ??
        airport["country"]?.toString().trim() ??
        "";
    final countryName = rawCountryName.isNotEmpty
        ? rawCountryName
        : await _countryService.resolveCountryName(countryCode);

    final result = {
      "cityName": cityName.isNotEmpty ? cityName : code,
      "countryName": countryName,
      "countryCode": countryCode,
      "latitude": (airport["lat"] as num?)?.toDouble() ?? 0.0,
      "longitude": (airport["lng"] as num?)?.toDouble() ?? 0.0,
    };
    _airportDetailsCache[code] = result;
    return result;
  }

  Future<Map<String, dynamic>> getFlightData({
    required String origin,
    required String destination,
    int windowDays = 7,
  }) async {
    final response = await _get(
      "/routes",
      params: {"dep_iata": origin, "arr_iata": destination},
    );

    final routes = response.data["response"] as List? ?? [];
    if (routes.isEmpty) {
      throw Exception("No direct route from $origin to $destination");
    }

    final route = routes.first;
    final depTimeStr = route["dep_time"]?.toString();
    final arrTimeStr = route["arr_time"]?.toString();
    final durationMins = int.tryParse(route["duration"]?.toString() ?? "") ?? 0;

    final rawDays = route["days"];
    final opDays = (rawDays is List)
        ? rawDays.map((d) => d.toString().toLowerCase()).toSet()
        : <String>{"mon", "tue", "wed", "thu", "fri", "sat", "sun"};

    const weekdays = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];
    DateTime? nextDep;
    final now = DateTime.now();
    for (int i = 1; i <= windowDays + 7; i++) {
      final d = now.add(Duration(days: i));
      if (opDays.contains(weekdays[d.weekday - 1])) {
        if (depTimeStr != null) {
          final parts = depTimeStr.split(':');
          final h = int.tryParse(parts[0]) ?? 0;
          final m = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
          nextDep = DateTime(d.year, d.month, d.day, h, m);
          break;
        }
      }
    }

    final arrDt = (nextDep != null && durationMins > 0)
        ? nextDep.add(Duration(minutes: durationMins))
        : null;

    final rawStops = route["stops"] as List? ?? [];
    final stops = rawStops
        .map((s) {
          final stop = s as Map;
          return {
            "airport": stop["airport_iata"]?.toString() ?? stop["iata_code"]?.toString() ?? "",
            "city": stop["city"]?.toString() ?? stop["city_name"]?.toString() ?? "",
            "latitude": (stop["lat"] as num?)?.toDouble() ?? 0.0,
            "longitude": (stop["lng"] as num?)?.toDouble() ?? 0.0,
          };
        })
        .toList();

    final airlineIata = route["airline_iata"]?.toString() ?? "";
    final airlineName = await _getAirlineName(airlineIata);
    final flightId = _buildFlightId(
      flightCode: route["flight_iata"]?.toString(),
      origin: origin,
      destination: destination,
      date: nextDep != null ? _formatDate(nextDep) : null,
    );

    return {
      "flightID": flightId,
      "flightId": flightId,
      "f": flightId,
      "flightCompany": airlineName,
      "flightCode": route["flight_iata"]?.toString(),
      "takeoffAirport": origin,
      "destinationAirport": destination,
      "takeoffTime": nextDep != null ? _formatTime(nextDep) : depTimeStr,
      "destinationTime": arrDt != null ? _formatTime(arrDt) : arrTimeStr,
      "departureDate": nextDep != null ? _formatDate(nextDep) : null,
      "arrivalDate": arrDt != null
          ? _formatDate(arrDt)
          : nextDep != null
          ? _formatDate(nextDep)
          : null,
      "takeoffCityName": origin,
      "destinationCityName": destination,
      "destinationCountryCode": "",
      "stops": stops,
    };
  }
}
