import 'package:massar/home%20screen/repositories/trip_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  final TripRepository tripRepository;

  TripCubit(this.tripRepository) : super(TripInitial());

  Future<void> fetchTrips({
  required String origin,
  required int budget,
}) async {
  try {
    List currentTrips = [];

    if (state is TripLoaded) {
      currentTrips = List.from((state as TripLoaded).trips);
    } else {
      emit(TripLoading());
    }

    final newTrips = await tripRepository.getTrips(
      origin: origin,
      budget: budget,
    );

    emit(
      TripLoaded([
        ...currentTrips,
        ...newTrips,
      ]),
    );
  } catch (e) {
    emit(TripError(e.toString()));
  }
}
}
