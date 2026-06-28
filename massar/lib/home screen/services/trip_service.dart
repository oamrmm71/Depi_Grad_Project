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

  Future<Map<String, dynamic>> getFlightData({
  required String origin,
  required String destination,
}) async {
  final now = DateTime.now().toUtc();

  final from =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T${now.hour.toString().padLeft(2, '0')}:00";

  final to = now.add(const Duration(hours: 12));

  final until =
      "${to.year}-${to.month.toString().padLeft(2, '0')}-${to.day.toString().padLeft(2, '0')}T${to.hour.toString().padLeft(2, '0')}:00";

  final response = await dio.get(
    "https://aerodatabox.p.rapidapi.com/flights/airports/iata/$origin",
    queryParameters: {
      "fromLocal": from,
      "toLocal": until,
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
        flight["departure"]?["scheduledTimeLocal"] ??
        "Unknown Time",

    "destinationTime":
        flight["arrival"]?["scheduledTimeLocal"] ??
        "Unknown Time",

    "takeoffCityName":
        flight["departure"]?["airport"]?["municipalityName"] ??
        origin,

    "destinationCityName":
        flight["arrival"]?["airport"]?["municipalityName"] ??
        destination,
  };
}
  Future<Map<String, dynamic>> getAirportDetails(String iata) async {
    final response = await dio.get(
      "https://aerodatabox.p.rapidapi.com/airports/iata/$iata",
      options: Options(
        headers: {
          "X-RapidAPI-Key": aerodataBoxApiKey,
          "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;
    var cityName = data["municipalityName"]?.toString().trim() ?? "";

    if (cityName.isEmpty) {
      cityName = _cityFromAirportName(
        data["shortName"]?.toString() ?? data["name"]?.toString() ?? "",
      );
    }

    if (cityName.isEmpty) {
      cityName = iata;
    }

    final countryCode = data["countryCode"]?.toString().trim() ?? "";
    final regionLabel = await _resolveCountryOrContinent(countryCode);

    return {
      "cityName": cityName,
      "regionLabel": regionLabel,
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

  Future<String> _resolveCountryOrContinent(String countryCode) async {
    if (countryCode.isEmpty) return "";

    try {
      final response = await dio.get(
        "https://restcountries.com/v3.1/alpha/$countryCode",
      );

      if (response.data is List && (response.data as List).isNotEmpty) {
        final country = (response.data as List).first as Map<String, dynamic>;
        final name = country["name"]?["common"]?.toString().trim();
        if (name != null && name.isNotEmpty) return name;

        final region = country["region"]?.toString().trim();
        if (region != null && region.isNotEmpty) return region;
      }
    } catch (_) {}

    return countryCode;
  }

  Future<Map<String, dynamic>> getPlaceData({
    required String cityName,
    required String regionName,
  }) async {
    final searchQuery =
        regionName.isNotEmpty ? "$cityName $regionName" : cityName;

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
      "locationName": regionName,
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
    return {
      "flightCompany": "TBD",
      "flightCode": "TBD",
      "takeoffAirport": origin,
      "destinationAirport": destination,
      "takeoffTime": "TBD",
      "destinationTime": "TBD",
      "takeoffCityName": origin,
      "destinationCityName": airportDetails["cityName"],
    };
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

        final placeData = await getPlaceData(
          cityName: cityName,
          regionName: airportDetails["regionLabel"]?.toString() ?? "",
        );

        trips.add({
          "cityName": cityName,
          "tripBudget": "$budget EGP",
          "locationName": placeData["locationName"],
          "locationImage": placeData["locationImage"],
          "departureDate": "13/7/2026",
          "arrivalDate": "20/7/2026",
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