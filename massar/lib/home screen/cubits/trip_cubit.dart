import 'package:massar/home%20screen/models/trip_model.dart';
import 'package:massar/home%20screen/repositories/trip_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  final TripRepository tripRepository;
  bool _isFetching = false;

  TripCubit(this.tripRepository) : super(TripInitial());

  Future<void> fetchTrips({
    required String origin,
    required int budget,
    bool loadMore = false,
    String? tripType,
  }) async {
    if (_isFetching) return;

    try {
      _isFetching = true;
      List<TripModel> currentTrips = [];

      if (tripType != null) {
        emit(TripLoading());
      } else if (state is TripLoaded) {
        currentTrips = List.from((state as TripLoaded).trips);
      } else if (!loadMore) {
        emit(TripLoading());
      }

      final excludeCities =
          currentTrips.map((trip) => trip.cityName).toList();

      final newTrips = await tripRepository.getTrips(
        origin: origin,
        budget: budget,
        excludeCities: excludeCities,
        tripType: tripType,
      );

      final existingCities =
          currentTrips.map((trip) => trip.cityName.toLowerCase()).toSet();

      final uniqueNewTrips = newTrips
          .where(
            (trip) => !existingCities.contains(trip.cityName.toLowerCase()),
          )
          .toList();

      emit(TripLoaded([...currentTrips, ...uniqueNewTrips]));
    } catch (e) {
      if (state is! TripLoaded) {
        emit(TripError(e.toString()));
      }
    } finally {
      _isFetching = false;
    }
  }
}
