import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TripService {
  final Dio dio = Dio();

  static final String aerodataBoxApiKey =
      dotenv.env["AERODATABOX_KEY"]!;
  static final String unsplashApiKey =
      dotenv.env["UNSPLASH_KEY"]!;
  static final String groqApiKey =
      dotenv.env["GROQ_KEY"]!;

  String _toLocalApiTimestamp(DateTime utc) {
    // AeroDataBox expects a local timestamp string; this keeps prior behavior
    // (UTC-based) while allowing a longer search window.
    return "${utc.year}-${utc.month.toString().padLeft(2, '0')}-${utc.day.toString().padLeft(2, '0')}T${utc.hour.toString().padLeft(2, '0')}:00";
  }

String _formatDate(DateTime dt) {
  return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
}

String _formatTime(DateTime dt) {
  return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
}

Future<Map<String, dynamic>> getFlightData({
  required String origin,
  required String destination,
  int windowDays = 7,
}) async {
  final now = DateTime.now().toUtc();

  final from = _toLocalApiTimestamp(now);
  final until = _toLocalApiTimestamp(
    now.add(Duration(days: windowDays)),
  );

  final response = await dio.get(
    "https://aerodatabox.p.rapidapi.com/flights/airports/iata/$origin/$from/$until",
    queryParameters: {
      "withLeg": true,
      "direction": "Departure",
      "withCancelled": false,
      "withCodeshared": true,
      "withCargo": false,
      "withPrivate": false,
    },
    options: Options(
      headers: {
        "X-RapidAPI-Key": aerodataBoxApiKey,
        "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
      },
    ),
  );

  final departures = response.data["departures"];

  if (departures == null || departures.isEmpty) {
    throw Exception("No departures found");
  }

  final matchingFlights = departures.where((flight) {
    final arrivalCode =
        flight["arrival"]?["airport"]?["iata"]?.toString();
    return arrivalCode == destination;
  }).toList();

  if (matchingFlights.isEmpty) {
    throw Exception("No flights to $destination");
  }

  final flight = matchingFlights.first;

  final depTimeRaw =
      flight["departure"]?["scheduledTimeLocal"]?.toString();

  final arrTimeRaw =
      flight["arrival"]?["scheduledTimeLocal"]?.toString();

  final depDt =
      depTimeRaw != null ? DateTime.tryParse(depTimeRaw) : null;

  final arrDt =
      arrTimeRaw != null ? DateTime.tryParse(arrTimeRaw) : null;

  return {
    "flightCompany":
        flight["airline"]?["name"] ?? "Unknown Airline",

    "flightCode":
        flight["number"] ?? "N/A",

    "takeoffAirport":
        flight["departure"]?["airport"]?["name"] ?? origin,

    "destinationAirport":
        flight["arrival"]?["airport"]?["name"] ?? destination,

    "takeoffTime":
        depDt != null ? _formatTime(depDt) : "TBD",

    "destinationTime":
        arrDt != null ? _formatTime(arrDt) : "TBD",

    "departureDate":
        depDt != null ? _formatDate(depDt) : "",

    "arrivalDate":
        arrDt != null ? _formatDate(arrDt) : "",

    "takeoffCityName":
        flight["departure"]?["airport"]?["municipalityName"] ??
        origin,

    "destinationCityName":
        flight["arrival"]?["airport"]?["municipalityName"] ??
        destination,

    "destinationCountryCode":
        flight["arrival"]?["airport"]?["countryCode"]
            ?.toString() ??
        "",
  };
}
  Future<Map<String, dynamic>> _lookupAirportBySearch(String iata) async {
    final response = await dio.get(
      "https://aerodatabox.p.rapidapi.com/airports/search/term",
      queryParameters: {"q": iata, "limit": "10"},
      options: Options(
        headers: {
          "X-RapidAPI-Key": aerodataBoxApiKey,
          "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
        },
      ),
    );

    final items = response.data["items"] as List? ?? [];
    final code = iata.toUpperCase();

    for (final item in items) {
      if (item is Map && item["iata"]?.toString().toUpperCase() == code) {
        return Map<String, dynamic>.from(item);
      }
    }

    if (items.isNotEmpty && items.first is Map) {
      return Map<String, dynamic>.from(items.first as Map);
    }

    throw Exception("Airport not found for $iata");
  }

  String _extractCountryCode(Map<String, dynamic> data) {
    final direct = data["countryCode"]?.toString().trim();
    if (direct != null && direct.isNotEmpty) return direct;

    final country = data["country"];
    if (country is Map) {
      for (final key in ["code", "iso2", "alpha2", "countryCode"]) {
        final value = country[key]?.toString().trim();
        if (value != null && value.isNotEmpty) return value;
      }
    }

    return "";
  }

  String? _extractCountryNameFromData(Map<String, dynamic> data) {
    final country = data["country"];
    if (country is! Map) return null;

    final name = country["name"];
    if (name is String && name.trim().isNotEmpty) return name.trim();
    if (name is Map) {
      for (final key in ["common", "en", "official"]) {
        final value = name[key]?.toString().trim();
        if (value != null && value.isNotEmpty) return value;
      }
    }

    for (final key in ["commonName", "fullName"]) {
      final value = country[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }

    return null;
  }

  Future<Map<String, dynamic>> getAirportDetails(String iata) async {
    Map<String, dynamic> data;

    try {
      final response = await dio.get(
        "https://aerodatabox.p.rapidapi.com/airports/iata/$iata",
        options: Options(
          headers: {
            "X-RapidAPI-Key": aerodataBoxApiKey,
            "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
          },
        ),
      );
      data = Map<String, dynamic>.from(response.data as Map);
    } catch (_) {
      data = await _lookupAirportBySearch(iata);
    }

    var cityName = data["municipalityName"]?.toString().trim() ?? "";

    if (cityName.isEmpty) {
      cityName = _cityFromAirportName(
        data["shortName"]?.toString() ?? data["name"]?.toString() ?? "",
      );
    }

    if (cityName.isEmpty) {
      cityName = iata;
    }

    final countryCode = _extractCountryCode(data);
    final countryNameFromApi = _extractCountryNameFromData(data);
    final countryName = countryNameFromApi != null && countryNameFromApi.isNotEmpty
        ? countryNameFromApi
        : await _resolveCountryName(countryCode);

    return {
      "cityName": cityName,
      "countryName": countryName,
      "countryCode": countryCode,
    };
  }

  String _cityFromAirportName(String airportName) {
    return airportName
        .replaceAll(
          RegExp(
            r'\s*(International|Intl\.?|Regional|Municipal|Airport|Air Base|Airfield)\s*',
            caseSensitive: false,
          ),
          ' ',
        )
        .trim();
  }

  Future<String> _resolveCountryName(String countryCode) async {
    if (countryCode.isEmpty) return "";

    final code = countryCode.toUpperCase();
    final cached = _countryCodeNames[code];
    if (cached != null) return cached;

    try {
      final response = await dio.get(
        "https://restcountries.com/v3.1/alpha/$code",
      );

      if (response.data is List && (response.data as List).isNotEmpty) {
        final country = (response.data as List).first as Map<String, dynamic>;
        final name = country["name"]?["common"]?.toString().trim();
        if (name != null && name.isNotEmpty) return name;
      }
    } catch (_) {}

    return code;
  }

  static const Map<String, String> _countryCodeNames = {
    'AE': 'United Arab Emirates',
    'AT': 'Austria',
    'AU': 'Australia',
    'BE': 'Belgium',
    'BG': 'Bulgaria',
    'BR': 'Brazil',
    'CA': 'Canada',
    'CH': 'Switzerland',
    'CN': 'China',
    'CY': 'Cyprus',
    'CZ': 'Czechia',
    'DE': 'Germany',
    'DK': 'Denmark',
    'EG': 'Egypt',
    'ES': 'Spain',
    'FI': 'Finland',
    'FR': 'France',
    'GB': 'United Kingdom',
    'GR': 'Greece',
    'HR': 'Croatia',
    'HU': 'Hungary',
    'ID': 'Indonesia',
    'IE': 'Ireland',
    'IN': 'India',
    'IT': 'Italy',
    'JP': 'Japan',
    'KE': 'Kenya',
    'KR': 'South Korea',
    'KW': 'Kuwait',
    'LB': 'Lebanon',
    'MA': 'Morocco',
    'MX': 'Mexico',
    'MY': 'Malaysia',
    'NG': 'Nigeria',
    'NL': 'Netherlands',
    'NO': 'Norway',
    'OM': 'Oman',
    'PH': 'Philippines',
    'PL': 'Poland',
    'PT': 'Portugal',
    'QA': 'Qatar',
    'RO': 'Romania',
    'RU': 'Russia',
    'SA': 'Saudi Arabia',
    'SE': 'Sweden',
    'SG': 'Singapore',
    'TH': 'Thailand',
    'TR': 'Turkey',
    'US': 'United States',
    'VN': 'Vietnam',
    'ZA': 'South Africa',
  };

  Future<Map<String, dynamic>> getPlaceData({
    required String cityName,
    required String countryName,
  }) async {
    final searchQuery =
        countryName.isNotEmpty ? "$cityName $countryName" : cityName;

    final imageResponse = await dio.get(
      "https://api.unsplash.com/search/photos",
      queryParameters: {
        "query": searchQuery,
        "client_id": unsplashApiKey,
        "per_page": 1,
      },
    );

    final imageResults = imageResponse.data["results"];

    final imageUrl =
        (imageResults != null && imageResults.isNotEmpty)
            ? imageResults.first["urls"]["regular"]
            : "https://images.unsplash.com/photo-1507525428034-b723cf961d3e";

    return {
      "locationImage": imageUrl,
    };
  }

  Future<List<String>> getAIDestinations({
  required int budget,
  required String origin,
  List<String> excludeCities = const [],
}) async {
  final excludeText = excludeCities.isNotEmpty
      ? " Do not suggest airports for these cities: ${excludeCities.join(', ')}."
      : "";

  final response = await dio.post(
    "https://api.groq.com/openai/v1/chat/completions",
    options: Options(
      headers: {
        "Authorization": "Bearer $groqApiKey",
        "Content-Type": "application/json",
      },
    ),
    data: {
      "model": "llama-3.1-8b-instant",
      "temperature": 1.2,
      "messages": [
        {
          "role": "system",
          "content":
              "Return ONLY 8 airport IATA codes separated by commas. Example: DXB,CDG,AMS,IST,SIN,BCN,ATH,CPH. No words, no sentences."
        },
        {
          "role": "user",
          "content": "Budget: $budget EGP. Origin airport: $origin.$excludeText"
        }
      ]
    },
  );

  final text =
      response.data["choices"][0]["message"]["content"]
          .toString()
          .trim();

  final destinations = text
      .split(",")
      .map((e) => e.trim().toUpperCase())
      .where((e) => RegExp(r'^[A-Z]{3}$').hasMatch(e))
      .where((e) => e != origin)
      .toList();

  print("Generated destinations: $destinations");

  return destinations;
}

  Map<String, dynamic> _placeholderFlightData({
    required String origin,
    required String destination,
    required Map<String, dynamic> airportDetails,
  }) {
    final seed = DateTime.now().millisecondsSinceEpoch;
    final departure = DateTime.now().add(Duration(days: 3 + (seed % 6)));
    final arrival = departure.add(Duration(days: 3 + ((seed ~/ 7) % 6)));

    return {
      "flightCompany": "Unknown Airline",
      "flightCode": "N/A",
      "takeoffAirport": origin,
      "destinationAirport": destination,
      "takeoffTime": _formatTime(departure),
"destinationTime": _formatTime(arrival),
      "departureDate": _formatDate(departure),
      "arrivalDate": _formatDate(arrival),
      "takeoffCityName": origin,
      "destinationCityName": airportDetails["cityName"],
      "destinationCountryCode": airportDetails["countryCode"]?.toString() ?? "",
    };
  }

  Future<String> _resolveTripCountryName({
    required Map<String, dynamic> airportDetails,
    required Map<String, dynamic> flightData,
  }) async {
    final fromAirport =
        airportDetails["countryName"]?.toString().trim() ?? "";
    if (fromAirport.isNotEmpty) return fromAirport;

    final fromFlight =
        flightData["destinationCountryCode"]?.toString().trim() ?? "";
    if (fromFlight.isNotEmpty) {
      return _resolveCountryName(fromFlight);
    }

    final fromAirportCode =
        airportDetails["countryCode"]?.toString().trim() ?? "";
    if (fromAirportCode.isNotEmpty) {
      return _resolveCountryName(fromAirportCode);
    }

    return "";
  }

  Future<List<Map<String, dynamic>>> getTripSuggestions({
    required String origin,
    required int budget,
    List<String> excludeCities = const [],
  }) async {
    final destinations = await getAIDestinations(
      budget: budget,
      origin: origin,
      excludeCities: excludeCities,
    );

    final excluded = excludeCities.map((c) => c.toLowerCase()).toSet();
    List<Map<String, dynamic>> trips = [];

    for (final destination in destinations) {
      try {
        final airportDetails = await getAirportDetails(destination);
        final cityName = airportDetails["cityName"]?.toString() ?? destination;

        if (excluded.contains(cityName.toLowerCase())) {
          continue;
        }

        Map<String, dynamic> flightData;
        try {
          flightData = await getFlightData(
            origin: origin,
            destination: destination,
          );
        } catch (_) {
          flightData = _placeholderFlightData(
            origin: origin,
            destination: destination,
            airportDetails: airportDetails,
          );
        }

        final countryName = await _resolveTripCountryName(
          airportDetails: airportDetails,
          flightData: flightData,
        );

        final placeData = await getPlaceData(
          cityName: cityName,
          countryName: countryName,
        );

        trips.add({
          "cityName": cityName,
          "countryName": countryName,
          "tripBudget": "$budget EGP",
          "locationName": countryName,
          "locationImage": placeData["locationImage"],
          "departureDate": (flightData["departureDate"]?.toString().trim().isNotEmpty ?? false)
              ? flightData["departureDate"]
              : (_placeholderFlightData(
                  origin: origin,
                  destination: destination,
                  airportDetails: airportDetails,
                )["departureDate"]),
          "arrivalDate": (flightData["arrivalDate"]?.toString().trim().isNotEmpty ?? false)
              ? flightData["arrivalDate"]
              : (_placeholderFlightData(
                  origin: origin,
                  destination: destination,
                  airportDetails: airportDetails,
                )["arrivalDate"]),
          "flightCompany": flightData["flightCompany"],
          "flightCode": flightData["flightCode"],
          "takeoffCity": flightData["takeoffCityName"],
          "takeoffAirport": flightData["takeoffAirport"],
          "takeoffTime": flightData["takeoffTime"],
          "destinationCity": flightData["destinationCityName"],
          "destinationAirport": flightData["destinationAirport"],
          "destinationTime": flightData["destinationTime"],
          "fullTripPlan": "Trip plan will be generated soon",
          "tours": [
            {
              "name": "City Tour",
              "price": "1000 EGP"
            },
            {
              "name": "Museum Visit",
              "price": "500 EGP"
            }
          ]
        });

        excluded.add(cityName.toLowerCase());

        if (trips.length >= 5) break;
      } catch (e) {
        print("Failed $destination -> $e");
      }
    }

    return trips;
  }
}