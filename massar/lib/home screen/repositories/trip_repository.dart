import 'package:massar/home%20screen/models/trip_model.dart';
import '../services/trip_service.dart';

class TripRepository {
  final TripService tripService;

  TripRepository(this.tripService);

  Future<List<TripModel>> getTrips({
    required String origin,
    required int budget,
    List<String> excludeCities = const [],
  }) async {
    final data = await tripService.getTripSuggestions(
      origin: origin,
      budget: budget,
      excludeCities: excludeCities,
    );

    return data.map((e) => TripModel.fromJson(e)).toList();
  }
}