import 'country_service.dart';
import 'flight_service.dart';
import 'groq_service.dart';
import 'image_service.dart';

class TripService {
  final FlightService _flightService;
  final GroqService _groqService;
  final ImageService _imageService;
  final CountryService _countryService;

  TripService({
    required FlightService flightService,
    required GroqService groqService,
    required ImageService imageService,
    required CountryService countryService,
  }) : _flightService = flightService,
       _groqService = groqService,
       _imageService = imageService,
       _countryService = countryService;

  Future<String> _resolveTripCountryName({
    required Map<String, dynamic> airportDetails,
    required Map<String, dynamic> flightData,
  }) async {
    final fromAirport = airportDetails["countryName"]?.toString().trim() ?? "";
    if (fromAirport.isNotEmpty) return fromAirport;

    final fromFlight =
        flightData["destinationCountryCode"]?.toString().trim() ?? "";
    if (fromFlight.isNotEmpty) {
      return _countryService.resolveCountryName(fromFlight);
    }

    final fromAirportCode =
        airportDetails["countryCode"]?.toString().trim() ?? "";
    if (fromAirportCode.isNotEmpty) {
      return _countryService.resolveCountryName(fromAirportCode);
    }

    return "";
  }

  Future<List<Map<String, dynamic>>> getTripSuggestions({
    required String origin,
    required int budget,
    List<String> excludeCities = const [],
    String? tripType,
  }) async {
    final destinations = await _groqService.getAIDestinations(
      budget: budget,
      origin: origin,
      excludeCities: excludeCities,
      tripType: tripType,
    );

    final cappedDestinations = destinations.take(5).toList();
    final excluded = excludeCities.map((c) => c.toLowerCase()).toSet();
    final List<Map<String, dynamic>> trips = [];

    for (final destination in cappedDestinations) {
      try {
        if (trips.isNotEmpty) {
          await Future.delayed(const Duration(milliseconds: 300));
        }

        final airportDetails = await _flightService.getAirportDetails(
          destination,
        );
        final cityName = airportDetails["cityName"]?.toString() ?? destination;

        if (excluded.contains(cityName.toLowerCase())) continue;

        Map<String, dynamic> flightData;
        bool usedFallback = false;

        try {
          flightData = await _flightService.getFlightData(
            origin: origin,
            destination: destination,
          );
        } catch (_) {
          usedFallback = true;
          flightData = {
            "flightID": '${origin}_to_${destination}',
            "flightCompany": null,
            "flightCode": null,
            "takeoffAirport": origin,
            "destinationAirport": destination,
            "takeoffTime": null,
            "destinationTime": null,
            "departureDate": null,
            "arrivalDate": null,
            "takeoffCityName": origin,
            "destinationCityName": cityName,
            "destinationCountryCode":
                airportDetails["countryCode"]?.toString() ?? "",
            "stops": [],
          };
        }

        final countryName = await _resolveTripCountryName(
          airportDetails: airportDetails,
          flightData: flightData,
        );

        final locationImage = await _imageService.getPlaceImage(
          cityName: cityName,
          countryName: countryName,
        );

        final ticketPrice = await _groqService.getTicketPrice(
          origin: origin,
          destination: destination,
        );

        Map<String, dynamic> returnFlightData = {
          "flightCompany": null,
          "flightCode": null,
          "departureDate": null,
          "arrivalDate": null,
          "takeoffTime": null,
          "destinationTime": null,
          "stops": [],
        };
        try {
          returnFlightData = await _flightService.getFlightData(
            origin: destination,
            destination: origin,
          );
        } catch (_) {}

        final tripPlan = await _groqService.generateTripPlan(
          cityName: cityName,
          countryName: countryName,
          budget: budget,
        );

        trips.add({
          "cityName": cityName,
          "countryName": countryName,
          "tripBudget": "$budget EGP",
          "locationName": countryName,
          "locationImage": locationImage,
          "departureDate": flightData["departureDate"],
          "arrivalDate": flightData["arrivalDate"],
          "flightID": flightData["flightID"] ?? flightData["f"],
          "flightCompany": flightData["flightCompany"],
          "flightCode": flightData["flightCode"],
          "ticketPrice": ticketPrice,
          "takeoffCity": flightData["takeoffCityName"],
          "takeoffAirport": flightData["takeoffAirport"],
          "takeoffTime": flightData["takeoffTime"],
          "destinationCity": cityName,
          "destinationAirport": flightData["destinationAirport"],
          "destinationTime": flightData["destinationTime"],
          "stops": flightData["stops"] ?? [],
          "returnFlightCompany": returnFlightData["flightCompany"],
          "returnFlightCode": returnFlightData["flightCode"],
          "returnDepartureDate": returnFlightData["departureDate"],
          "returnArrivalDate": returnFlightData["arrivalDate"],
          "returnTakeoffTime": returnFlightData["takeoffTime"],
          "returnDestinationTime": returnFlightData["destinationTime"],
          "returnStops": returnFlightData["stops"] ?? [],
          "isRealFlightData": !usedFallback,
          "fullTripPlan": "Trip plan will be generated soon",
          "tripPlan": tripPlan,
          "tours": [
            {"name": "City Tour", "price": "1000 EGP"},
            {"name": "Museum Visit", "price": "500 EGP"},
          ],
        });

        excluded.add(cityName.toLowerCase());
        if (trips.length >= 5) break;
      } catch (e) {
        print("Failed to process destination $destination: $e");
      }
    }

    return trips;
  }

  Future<Map<String, dynamic>?> getDreamTrip({
    required String origin,
    required String cityName,
    required String countryName,
    required int budget,
  }) async {
    try {
      final destinationAirport = await _flightService.getAirportCodeForCity(
        cityName: cityName,
        countryName: countryName,
      );

      final resolvedDestinationAirport = destinationAirport ?? cityName;
      final airportDetails = destinationAirport != null
          ? await _flightService.getAirportDetails(destinationAirport)
          : <String, dynamic>{
              "cityName": cityName,
              "countryName": countryName,
              "countryCode": "",
            };

      final airportCountryNameValue = airportDetails["countryName"]?.toString();
      final airportCountryName = airportCountryNameValue?.trim() ?? "";
      final resolvedCountryName =
          airportCountryName.isNotEmpty ? airportCountryName : countryName;

      final locationImage = await _imageService.getPlaceImage(
        cityName: cityName,
        countryName: resolvedCountryName,
      );

      Map<String, dynamic> flightData = {
        "flightID": "${origin}_to_${resolvedDestinationAirport}",
        "flightCompany": null,
        "flightCode": null,
        "takeoffAirport": origin,
        "destinationAirport": resolvedDestinationAirport,
        "takeoffTime": null,
        "destinationTime": null,
        "departureDate": null,
        "arrivalDate": null,
        "takeoffCityName": origin,
        "destinationCityName": cityName,
        "destinationCountryCode": airportDetails["countryCode"]?.toString() ?? "",
      };

      bool usedFallback = true;
      try {
        if (destinationAirport != null) {
          flightData = await _flightService.getFlightData(
            origin: origin,
            destination: destinationAirport,
          );
          usedFallback = false;
        }
      } catch (_) {}

      Map<String, dynamic> returnFlightData = {
        "flightCompany": null,
        "flightCode": null,
        "departureDate": null,
        "arrivalDate": null,
        "takeoffTime": null,
        "destinationTime": null,
      };
      try {
        if (destinationAirport != null) {
          returnFlightData = await _flightService.getFlightData(
            origin: destinationAirport,
            destination: origin,
          );
        }
      } catch (_) {}

      final ticketPrice = destinationAirport == null
          ? null
          : await _groqService.getTicketPrice(
              origin: origin,
              destination: destinationAirport,
            );

      final tripPlan = await _groqService.generateTripPlan(
        cityName: cityName,
        countryName: resolvedCountryName,
        budget: budget,
      );

      return {
        "cityName": cityName,
        "countryName": resolvedCountryName,
        "tripBudget": "$budget EGP",
        "locationName": resolvedCountryName,
        "locationImage": locationImage,
        "departureDate": flightData["departureDate"],
        "arrivalDate": flightData["arrivalDate"],
        "flightID": flightData["flightID"] ?? flightData["f"],
        "flightCompany": flightData["flightCompany"],
        "flightCode": flightData["flightCode"],
        "ticketPrice": ticketPrice,
        "takeoffCity": flightData["takeoffCityName"],
        "takeoffAirport": flightData["takeoffAirport"],
        "takeoffTime": flightData["takeoffTime"],
        "destinationCity": cityName,
        "destinationAirport": flightData["destinationAirport"],
        "destinationTime": flightData["destinationTime"],
        "returnFlightCompany": returnFlightData["flightCompany"],
        "returnFlightCode": returnFlightData["flightCode"],
        "returnDepartureDate": returnFlightData["departureDate"],
        "returnArrivalDate": returnFlightData["arrivalDate"],
        "returnTakeoffTime": returnFlightData["takeoffTime"],
        "returnDestinationTime": returnFlightData["destinationTime"],
        "isRealFlightData": !usedFallback,
        "fullTripPlan": tripPlan == null
            ? "Trip plan will be generated soon"
            : [
                if (tripPlan.accommodations.isNotEmpty)
                  "Hotel: ${tripPlan.accommodations.first.hotelName}",
                if (tripPlan.attractions.isNotEmpty)
                  "Top place: ${tripPlan.attractions.first.name}",
              ].join(" | "),
        "tripPlan": tripPlan,
        "tours": tripPlan?.attractions
                .map(
                  (attraction) => {
                    "name": attraction.name,
                    "price": "${attraction.feeEgp ?? 0} EGP",
                  },
                )
                .toList() ??
            [],
      };
    } catch (e) {
      print("getDreamTrip error: $e");
      return null;
    }
  }
}
