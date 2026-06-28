import 'package:dio/dio.dart';

class TripService {
  final Dio dio = Dio();

  static const String aviationApiKey = "21359e75b1a7169412a8fe4ef3b9329d";
  static const String unsplashApiKey = "l37ym7qUIAFPcIDikpzxh191MfGoKjT7Kq9QNh3U5X8";

  Future<Map<String, dynamic>> getFlightData({
    required String origin,
    required String destination,
  }) async {
    final response = await dio.get(
      "http://api.aviationstack.com/v1/flights",
      queryParameters: {
        "access_key": aviationApiKey,
        "dep_iata": origin,
        "arr_iata": destination,
      },
    );

    final flight = response.data["data"][0];

    return {
      "flightCompany": flight["airline"]["name"],
      "flightCode": flight["flight"]["iata"],
      "takeoffAirport": flight["departure"]["airport"],
      "destinationAirport": flight["arrival"]["airport"],
      "takeoffTime": flight["departure"]["scheduled"],
      "destinationTime": flight["arrival"]["scheduled"],
      "takeoffCityName":
          flight["departure"]["timezone"].toString().split("/").last,
      "destinationCityName":
          flight["arrival"]["timezone"].toString().split("/").last,
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

    final placeName = wikiResponse.data["query"]["search"][0]["title"];

    final imageResponse = await dio.get(
      "https://api.unsplash.com/search/photos",
      queryParameters: {
        "query": destination,
        "client_id": unsplashApiKey,
        "per_page": 1,
      },
    );

    final imageUrl = imageResponse.data["results"][0]["urls"]["regular"];

    return {
      "locationName": placeName,
      "locationImage": imageUrl,
    };
  }

  Future<List<Map<String, dynamic>>> getTripSuggestions({
    required String origin,
    required List<String> destinations,
    required int budget,
  }) async {
    try {
      List<Map<String, dynamic>> trips = [];

      for (final destination in destinations) {
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
      }

      return trips;
    } catch (e) {
      throw Exception("Failed to fetch trip data: $e");
    }
  }
}