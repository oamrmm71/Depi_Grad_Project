import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:massar/home%20screen/cubits/trip_cubit.dart';
import 'package:massar/home%20screen/cubits/trip_state.dart';
import 'package:massar/flights%20screen/models/flight_model.dart';
import 'flight_state.dart';
import 'dart:async';

class FlightCubit extends Cubit<FlightState> {
  final TripCubit tripCubit;
  late final StreamSubscription<TripState> _tripSubscription;

  FlightCubit(this.tripCubit) : super(FlightInitial()) {
    _tripSubscription = tripCubit.stream.listen(_onTripStateChanged);
    _onTripStateChanged(tripCubit.state);
  }

  void _onTripStateChanged(TripState tripState) {
    if (tripState is TripLoading) {
      emit(FlightLoading());
      return;
    }

    if (tripState is TripError) {
      emit(FlightError(tripState.message));
      return;
    }

    if (tripState is TripLoaded) {
      final flights = <FlightModel>[];

      for (final trip in tripState.trips) {
        if (trip.flightCode != null || trip.departureDate != null) {
          flights.add(FlightModel.fromTrip(trip));
        }
        if (trip.returnFlightCode != null ||
            trip.returnDepartureDate != null) {
          flights.add(FlightModel.fromTrip(trip, isReturn: true));
        }
      }

      emit(FlightLoaded(flights));
    }
  }

  @override
  Future<void> close() {
    _tripSubscription.cancel();
    return super.close();
  }
}