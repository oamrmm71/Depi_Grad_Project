import 'package:massar/home%20screen/repositories/trip_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  final TripRepository tripRepository;

  TripCubit(this.tripRepository) : super(TripInitial());

  Future<void> fetchTrip({
    required String origin,
    required String destination,
    required int budget,
  }) async {
    try {
      emit(TripLoading());

      final trip = await tripRepository.getTrip(
        origin: origin,
        destination: destination,
        budget: budget,
      );

      emit(TripLoaded(trip));
    } catch (e) {
      emit(TripError(e.toString()));
    }
  }
}