import 'package:massar/home%20screen/models/trip_model.dart';
import 'package:massar/home%20screen/repositories/trip_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  final TripRepository tripRepository;
  bool _isFetching = false;
  TripModel? _dreamTrip;

  TripCubit(this.tripRepository) : super(TripInitial());

  List<TripModel> _withDreamTrip(List<TripModel> trips) {
    final dreamTrip = _dreamTrip;
    if (dreamTrip == null) return trips;

    final filteredTrips = trips
        .where(
          (trip) =>
              trip.cityName.toLowerCase() != dreamTrip.cityName.toLowerCase(),
        )
        .toList();
    return [dreamTrip, ...filteredTrips];
  }

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

      emit(TripLoaded(_withDreamTrip([...currentTrips, ...uniqueNewTrips])));
    } catch (e) {
      if (state is! TripLoaded) {
        emit(TripError(e.toString()));
      }
    } finally {
      _isFetching = false;
    }
  }

  Future<void> loadDreamTrip({
    required String origin,
    required String cityName,
    required String countryName,
    required int budget,
  }) async {
    try {
      final dreamTrip = await tripRepository.getDreamTrip(
        origin: origin,
        cityName: cityName,
        countryName: countryName,
        budget: budget,
      );

      if (dreamTrip == null) return;

      _dreamTrip = dreamTrip;

      if (state is TripLoaded) {
        final existingTrips = List<TripModel>.from((state as TripLoaded).trips);
        emit(TripLoaded(_withDreamTrip(existingTrips)));
      } else {
        emit(TripLoaded([dreamTrip]));
      }
    } catch (_) {}
  }
}
