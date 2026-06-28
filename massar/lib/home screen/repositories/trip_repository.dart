import 'package:massar/home%20screen/models/trip_model.dart';
import '../services/trip_service.dart';

class TripRepository {
  final TripService tripService;

  TripRepository(this.tripService);

  Future<List<TripModel>> getTrips({
    required String origin,
    required List<String> destinations,
    required int budget,
  }) async {
    final data = await tripService.getTripSuggestions(
      origin: origin,
      destinations: destinations,
      budget: budget,
    );

    return data.map((e) => TripModel.fromJson(e)).toList();
  }
}