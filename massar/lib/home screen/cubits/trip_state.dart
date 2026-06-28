import 'package:massar/home%20screen/models/trip_model.dart';

abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final TripModel trip;

  TripLoaded(this.trip);
}

class TripError extends TripState {
  final String message;

  TripError(this.message);
}