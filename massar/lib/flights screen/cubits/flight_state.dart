import 'package:massar/flights%20screen/models/flight_model.dart';

abstract class FlightState {}

class FlightInitial extends FlightState {}

class FlightLoading extends FlightState {}

class FlightLoaded extends FlightState {
  final List<FlightModel> flights;

  FlightLoaded(this.flights);
}

class FlightError extends FlightState {
  final String message;

  FlightError(this.message);
}