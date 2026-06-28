import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TripService {
  final Dio dio = Dio();

  static final String aviationApiKey = dotenv.env["AVIATION_KEY"]!;
  static final String unsplashApiKey = dotenv.env["UNSPLASH_KEY"]!;
  static final String groqApiKey = dotenv.env["GROQ_KEY"]!;
  Future<Map<String, dynamic>> getFlightData({
    required String origin,
    required String destination,
  }) async {
    final response = await dio.get(
      "https://api.aviationstack.com/v1/flights",
      queryParameters: {
        "access_key": aviationApiKey,
        "dep_iata": origin,
        "arr_iata": destination,
      },
    );

    final flights = response.data["data"];

    if (flights == null || flights.isEmpty) {
      throw Exception("No flights found for $origin → $destination");
    }

    final flight = flights.first;

    return {
      "flightCompany": flight["airline"]?["name"] ?? "Unknown Airline",
      "flightCode": flight["flight"]?["iata"] ?? "N/A",
      "takeoffAirport": flight["departure"]?["airport"] ?? "Unknown Airport",
      "destinationAirport": flight["arrival"]?["airport"] ?? "Unknown Airport",
      "takeoffTime": flight["departure"]?["scheduled"] ?? "Unknown Time",
      "destinationTime": flight["arrival"]?["scheduled"] ?? "Unknown Time",

      "takeoffCityName":
          flight["departure"]?["timezone"]
                  ?.toString()
                  .split("/")
                  .last ??
              origin,

      "destinationCityName":
          flight["arrival"]?["timezone"]
                  ?.toString()
                  .split("/")
                  .last ??
              destination,
    };
  }

  Future<Map<String, dynamic>> getPlaceData(String destination) async {
    final wikiResponse = await dio.get(
      "https://en.wikipedia.org/w/api.php",
      queryParameters: {
        "action": "query",
        "list": "search",
        "format": "json",
        "srsearch": destination,
      },
    );

    final wikiResults = wikiResponse.data["query"]?["search"];

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
  }) async {
    final seed = DateTime.now().millisecondsSinceEpoch;

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
        "temperature": 1.4,
        "messages": [
          {
            "role": "system",
            "content":
                "Generate exactly 10 VALID airport IATA codes (3 letters only) for major international tourist destinations. Examples: CDG, LHR, JFK, NRT, DXB. Return ONLY comma-separated airport codes. No explanations."
          },
          {
            "role": "user",
            "content": "Budget: $budget EGP. Random seed: $seed"
          }
        ]
      },
    );

    final choices = response.data["choices"];

    if (choices == null || choices.isEmpty) {
      throw Exception("Groq returned no destinations");
    }

    final String text = choices.first["message"]["content"].toString();

    final List<String> destinations = text
        .split(",")
        .map((e) => e.toString().trim().toUpperCase())
        .map((e) => e.replaceAll(RegExp(r'[^A-Z]'), ''))
        .where((e) => e.length == 3)
        .toSet()
        .toList();

    print("Generated destinations: $destinations");

    return destinations;
  }

  Future<List<Map<String, dynamic>>> getTripSuggestions({
    required String origin,
    required int budget,
  }) async {
    try {
      final destinations = await getAIDestinations(
        budget: budget,
      );

      List<Map<String, dynamic>> trips = [];

      for (final destination in destinations) {
        try {
          print("Trying destination: $destination");

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

            "destinationCity": flightData["destinationCityName"],
            "destinationAirport": flightData["destinationAirport"],
            "destinationTime": flightData["destinationTime"],

            "fullTripPlan": "Trip plan will be generated soon",

            "tours": [
              {"name": "City Tour", "price": "1000 EGP"},
              {"name": "Museum Visit", "price": "500 EGP"},
            ],
          });
        } catch (e) {
          print("Failed destination: $destination → $e");
          continue;
        }
      }

      print("Trips count: ${trips.length}");

      return trips;
    } catch (e) {
      throw Exception("Failed to fetch trip data: $e");
    }
  }
}