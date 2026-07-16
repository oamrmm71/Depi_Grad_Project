import 'trip_plan_model.dart';

class TripModel {
  final String cityName;
  final String countryName;
  final String tripBudget;
  final String locationName;
  final String locationImage;
  final String? departureDate;
  final String? arrivalDate;
  final String? flightCompany;
  final String? flightCode;
  final String? ticketPrice;
  final String takeoffCity;
  final String takeoffAirport;
  final String? takeoffTime;
  final String destinationCity;
  final String destinationAirport;
  final String? destinationTime;
  final String? returnFlightCompany;
  final String? returnFlightCode;
  final String? returnDepartureDate;
  final String? returnArrivalDate;
  final String? returnTakeoffTime;
  final String? returnDestinationTime;
  final List<TourModel> tours;
  final String fullTripPlan;
  final TripPlanModel? tripPlan;

  TripModel({
    required this.cityName,
    required this.countryName,
    required this.tripBudget,
    required this.locationName,
    required this.locationImage,
    this.departureDate,
    this.arrivalDate,
    this.flightCompany,
    this.flightCode,
    this.ticketPrice,
    required this.takeoffCity,
    required this.takeoffAirport,
    this.takeoffTime,
    required this.destinationCity,
    required this.destinationAirport,
    this.destinationTime,
    this.returnFlightCompany,
    this.returnFlightCode,
    this.returnDepartureDate,
    this.returnArrivalDate,
    this.returnTakeoffTime,
    this.returnDestinationTime,
    required this.tours,
    required this.fullTripPlan,
    this.tripPlan,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      cityName: json["cityName"] ?? "Unknown",
      countryName:
          json["countryName"] ?? json["locationName"] ?? "",
      tripBudget: json["tripBudget"]?.toString() ?? "0",
      locationName: json["locationName"] ?? "",
      locationImage: json["locationImage"] ?? "",

      departureDate: json["departureDate"],
      arrivalDate: json["arrivalDate"],

      flightCompany: json["flightCompany"],
      flightCode: json["flightCode"],
      ticketPrice: json["ticketPrice"]?.toString(),

      takeoffCity: json["takeoffCity"] ?? "",
      takeoffAirport: json["takeoffAirport"] ?? "",
      takeoffTime: json["takeoffTime"],

      destinationCity: json["destinationCity"] ?? "",
      destinationAirport: json["destinationAirport"] ?? "",
      destinationTime: json["destinationTime"],

      returnFlightCompany: json["returnFlightCompany"],
      returnFlightCode: json["returnFlightCode"],
      returnDepartureDate: json["returnDepartureDate"],
      returnArrivalDate: json["returnArrivalDate"],
      returnTakeoffTime: json["returnTakeoffTime"],
      returnDestinationTime: json["returnDestinationTime"],

      tours: (json["tours"] as List<dynamic>?)
              ?.map(
                (e) => TourModel.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList() ??
          [],

      fullTripPlan: json["fullTripPlan"] ?? "",

      tripPlan: json["tripPlan"] != null
          ? TripPlanModel.fromJson(
              Map<String, dynamic>.from(json["tripPlan"]),
            )
          : null,
    );
  }
}

class TourModel {
  final String name;
  final String price;

  TourModel({
    required this.name,
    required this.price,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      name: json["name"] ?? "",
      price: json["price"]?.toString() ?? "0",
    );
  }
}