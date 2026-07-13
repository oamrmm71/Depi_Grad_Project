import 'package:massar/home%20screen/models/trip_model.dart';

class FlightModel {
  final String flightType; 
  final String flightCompany;
  final String flightCode;
  final String date;
  final String fromCountry;
  final String fromAirport;
  final String fromTime;
  final String toCountry;
  final String toAirport;
  final String toTime;

  FlightModel({
    required this.flightType,
    required this.flightCompany,
    required this.flightCode,
    required this.date,
    required this.fromCountry,
    required this.fromAirport,
    required this.fromTime,
    required this.toCountry,
    required this.toAirport,
    required this.toTime,
  });

  factory FlightModel.fromTrip(TripModel trip, {bool isReturn = false}) {
    if (isReturn) {
      return FlightModel(
        flightType: 'Return Flight',
        flightCompany: trip.returnFlightCompany ?? 'TBD',
        flightCode: trip.returnFlightCode ?? 'TBD',
        date: trip.returnDepartureDate ?? 'TBD',
        fromCountry: trip.destinationCity,
        fromAirport: trip.destinationAirport,
        fromTime: trip.returnTakeoffTime ?? 'TBD',
        toCountry: trip.takeoffCity,
        toAirport: trip.takeoffAirport,
        toTime: trip.returnDestinationTime ?? 'TBD',
      );
    }
    return FlightModel(
      flightType: 'Transit Flight',
      flightCompany: trip.flightCompany ?? 'TBD',
      flightCode: trip.flightCode ?? 'TBD',
      date: trip.departureDate ?? 'TBD',
      fromCountry: trip.takeoffCity,
      fromAirport: trip.takeoffAirport,
      fromTime: trip.takeoffTime ?? 'TBD',
      toCountry: trip.destinationCity,
      toAirport: trip.destinationAirport,
      toTime: trip.destinationTime ?? 'TBD',
    );
  }
}