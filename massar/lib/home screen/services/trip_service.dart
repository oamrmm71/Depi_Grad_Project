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
  Future<Map<String, dynamic>> getPlaceData(
      String destination) async {
    final wikiResponse = await dio.get(
      "https://en.wikipedia.org/w/api.php",
      queryParameters: {
        "action": "query",
        "list": "search",
        "format": "json",
        "srsearch": destination,
      },
    );

    final wikiResults =
        wikiResponse.data["query"]?["search"];

    final placeName =
        (wikiResults != null && wikiResults.isNotEmpty)
            ? wikiResults.first["title"]
            : destination;

    final imageResponse = await dio.get(
      "https://api.unsplash.com/search/photos",
      queryParameters: {
        "query": destination,
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
      "locationName": placeName,
      "locationImage": imageUrl,
    };
  }

  Future<List<String>> getAIDestinations({
  required int budget,
  required String origin,
}) async {
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
              "Return ONLY 5 airport IATA codes separated by commas. Example: DXB,CDG,AMS,IST,SIN. No words, no sentences."
        },
        {
          "role": "user",
          "content": "Budget: $budget EGP"
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

  Future<List<Map<String, dynamic>>> getTripSuggestions({
    required String origin,
    required int budget,
  }) async {
    final destinations = await getAIDestinations(
      budget: budget,
      origin: origin,
    );

    List<Map<String, dynamic>> trips = [];

    for (final destination in destinations) {
      try {
        final flightData = await getFlightData(
          origin: origin,
          destination: destination,
        );

        final placeData = await getPlaceData(
          flightData["destinationCityName"],
        );

        trips.add({
          "cityName": flightData["destinationCityName"],
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
          "destinationCity":
              flightData["destinationCityName"],
          "destinationAirport":
              flightData["destinationAirport"],
          "destinationTime":
              flightData["destinationTime"],
          "fullTripPlan":
              "Trip plan will be generated soon",
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

        if (trips.length >= 5) break;
      } catch (e) {
        print("Failed $destination -> $e");
      }
    }

    return trips;
  }
}