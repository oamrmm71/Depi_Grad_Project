import 'package:massar/home%20screen/repositories/trip_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  final TripRepository tripRepository;

  TripCubit(this.tripRepository) : super(TripInitial());

  Future<void> fetchTrips({
    required String origin,
    required List<String> destinations,
    required int budget,
  }) async {
    try {
      emit(TripLoading());

      final trips = await tripRepository.getTrips(
        origin: origin,
        destinations: destinations,
        budget: budget,
      );

      emit(TripLoaded(trips));
    } catch (e) {
      emit(TripError(e.toString()));
    }
  }
}