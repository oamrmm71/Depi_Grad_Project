import 'package:massar/home%20screen/models/trip_model.dart';

import '../services/trip_service.dart';

class TripRepository {
  final TripService tripService;

  TripRepository(this.tripService);

  Future<TripModel> getTrip({
    required String origin,
    required String destination,
    required int budget,
  }) async {
    final data = await tripService.getTripSuggestions(
      origin: origin,
      destination: destination,
      budget: budget,
    );

    return TripModel.fromJson(data);
  }
}