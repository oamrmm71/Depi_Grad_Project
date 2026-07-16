import 'package:massar/home%20screen/models/trip_model.dart';

class FlightModel {
  final String flightId;
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
    required this.flightId,
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

  Map<String, dynamic> toJson() {
    return {
      'flightId': flightId,
      'flightType': flightType,
      'flightCompany': flightCompany,
      'flightCode': flightCode,
      'date': date,
      'fromCountry': fromCountry,
      'fromAirport': fromAirport,
      'fromTime': fromTime,
      'toCountry': toCountry,
      'toAirport': toAirport,
      'toTime': toTime,
    };
  }

  static String _buildFlightId(
    String? flightCode,
    String flightType,
    String fromAirport,
    String toAirport,
    String date,
  ) {
    if (flightCode != null && flightCode.trim().isNotEmpty) {
      return flightCode.trim();
    }

    final sanitizedDate = date.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
    final sanitizedFrom = fromAirport.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
    final sanitizedTo = toAirport.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
    return '${flightType.replaceAll(' ', '_')}_${sanitizedFrom}_to_${sanitizedTo}_date_${sanitizedDate}'
        .replaceAll(' ', '_');
  }

  factory FlightModel.fromTrip(TripModel trip, {bool isReturn = false}) {
    if (isReturn) {
      final flightCode = trip.returnFlightCode ?? 'TBD';
      final date = trip.returnDepartureDate ?? 'TBD';
      final fromAirport = trip.destinationAirport;
      final toAirport = trip.takeoffAirport;
      return FlightModel(
        flightId: _buildFlightId(
          trip.returnFlightCode,
          'Return Flight',
          fromAirport,
          toAirport,
          date,
        ),
        flightType: 'Return Flight',
        flightCompany: trip.returnFlightCompany ?? 'TBD',
        flightCode: flightCode,
        date: date,
        fromCountry: trip.destinationCity,
        fromAirport: fromAirport,
        fromTime: trip.returnTakeoffTime ?? 'TBD',
        toCountry: trip.takeoffCity,
        toAirport: toAirport,
        toTime: trip.returnDestinationTime ?? 'TBD',
      );
    }
    return FlightModel(
      flightId: _buildFlightId(
        trip.flightCode,
        'Transit Flight',
        trip.takeoffAirport,
        trip.destinationAirport,
        trip.departureDate ?? 'TBD',
      ),
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
  factory FlightModel.fromFirestore(
  Map<String, dynamic> json,
) {
  return FlightModel(
    flightId: json['flightId'] ?? '',
    flightType: json['flightType'] ?? 'Flight',
    flightCompany: json['flightCompany'] ?? '',
    flightCode: json['flightCode'] ?? '',
    date: json['date'] ?? '',
    fromCountry: json['fromCountry'] ?? '',
    fromAirport: json['fromAirport'] ?? '',
    fromTime: json['fromTime'] ?? '',
    toCountry: json['toCountry'] ?? '',
    toAirport: json['toAirport'] ?? '',
    toTime: json['toTime'] ?? '',
  );
}
}
