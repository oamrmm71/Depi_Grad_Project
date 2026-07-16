import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:massar/custom%20widgets/page_title.dart';
import 'package:massar/flights%20screen/models/flight_model.dart';
import 'package:massar/home%20screen/services/country_service.dart';
import 'package:massar/home%20screen/services/flight_service.dart';
import 'package:massar/custom widgets/app_background.dart';
import 'package:massar/theme/app_colors.dart';

class _ItineraryPlace {
  final String name;
  final LatLng point;

  _ItineraryPlace({required this.name, required this.point});
}

class FlightRouteScreen extends StatefulWidget {
  final FlightModel flight;

  const FlightRouteScreen({
    super.key,
    required this.flight,
  });

  @override
  State<FlightRouteScreen> createState() =>
      _FlightRouteScreenState();
}

class _FlightRouteScreenState extends State<FlightRouteScreen> {
  late final FlightService _flightService;
  final Dio _geocodeDio = Dio();

  bool _loading = true;
  String? _error;

  late LatLng _origin;
  late LatLng _destination;

  String _originCity = '';
  String _destinationCity = '';

  List<_ItineraryPlace> _itineraryPlaces = [];

  List<LatLng> get _stopPoints => widget.flight.stops
      .map((s) => LatLng(s.latitude, s.longitude))
      .toList();

  Future<LatLng?> _geocodePlace(String query) async {
    try {
      final response = await _geocodeDio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': 1,
        },
        options: Options(
          headers: {'User-Agent': 'massar-travel-app/1.0'},
        ),
      );

      final results = response.data as List;
      if (results.isEmpty) return null;

      final result = results.first as Map;
      final lat = double.tryParse(result['lat'].toString());
      final lon = double.tryParse(result['lon'].toString());
      if (lat == null || lon == null) return null;

      return LatLng(lat, lon);
    } catch (_) {
      return null;
    }
  }

  Future<List<_ItineraryPlace>> _geocodeItineraryStops(
    String destinationCity,
  ) async {
    final places = <_ItineraryPlace>[];

    for (final name in widget.flight.itineraryStops) {
      final point = await _geocodePlace('$name, $destinationCity');
      if (point != null) {
        places.add(_ItineraryPlace(name: name, point: point));
      }
      // Nominatim's public API allows at most 1 request/second.
      await Future.delayed(const Duration(milliseconds: 1100));
    }

    return places;
  }

  @override
  void initState() {
    super.initState();

    _flightService = FlightService(
      countryService: CountryService(),
    );

    _loadRoute();
  }

  Future<void> _loadRoute() async {
    try {
      final originData =
          await _flightService.getAirportDetails(
        widget.flight.fromAirport,
      );

      final destinationData =
          await _flightService.getAirportDetails(
        widget.flight.toAirport,
      );

      _origin = LatLng(
        originData["latitude"],
        originData["longitude"],
      );

      _destination = LatLng(
        destinationData["latitude"],
        destinationData["longitude"],
      );

      _originCity =
          originData["cityName"];

      _destinationCity =
          destinationData["cityName"];

      debugPrint(
        "Itinerary stops on flight (${widget.flight.flightId}): "
        "${widget.flight.itineraryStops}",
      );

      final itineraryPlaces = widget.flight.itineraryStops.isEmpty
          ? <_ItineraryPlace>[]
          : await _geocodeItineraryStops(_destinationCity);

      debugPrint(
        "Geocoded ${itineraryPlaces.length}/"
        "${widget.flight.itineraryStops.length} itinerary places: "
        "${itineraryPlaces.map((p) => '${p.name} -> ${p.point}').toList()}",
      );

      if (mounted) {
        setState(() {
          _itineraryPlaces = itineraryPlaces;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            _error!,
            style: const TextStyle(
              color: AppColors.navIcon,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          const AppBackground(),

          FlutterMap(
            options: MapOptions(
              initialCameraFit: CameraFit.bounds(
                bounds: LatLngBounds.fromPoints([
                  _origin,
                  ..._stopPoints,
                  _destination,
                  ..._itineraryPlaces.map((p) => p.point),
                ]),
                padding: const EdgeInsets.fromLTRB(
                  60,
                  180,
                  60,
                  120,
                ),
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                subdomains: const [
                  'a',
                  'b',
                  'c',
                  'd',
                ],
                userAgentPackageName:
                    'com.yourcompany.massar',
              ),

              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [
                      _origin,
                      ..._stopPoints,
                      _destination,
                    ],
                    strokeWidth: 3,
                    color: AppColors.navIcon,
                  ),
                ],
              ),

              MarkerLayer(
                markers: [
                  Marker(
                    point: _origin,
                    width: 18,
                    height: 18,
                    child: const _DotMarker(),
                  ),

                  Marker(
                    point: _destination,
                    width: 34,
                    height: 34,
                    child: const Icon(
                      Icons.flight,
                      color: AppColors.navIcon,
                      size: 28,
                    ),
                  ),

                  for (final stop in widget.flight.stops)
                    Marker(
                      point: LatLng(stop.latitude, stop.longitude),
                      width: 60,
                      height: 40,
                      child: _StopMarker(code: stop.airport),
                    ),

                  for (final place in _itineraryPlaces)
                    Marker(
                      point: place.point,
                      width: 90,
                      height: 44,
                      child: _ItineraryMarker(name: place.name),
                    ),
                ],
              ),
            ],
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const PageTitle(
                    firstLine: "TRIP",
                    secondLine: "ROUTE",
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color:
                                Colors.black.withOpacity(.1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.navIcon,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(.08),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  _AirportLabel(
                    code:
                        widget.flight.fromAirport,
                    city:
                        _originCity,
                  ),

                  const Icon(
                    Icons.flight,
                    color: AppColors.navIcon,
                    size: 20,
                  ),

                  _AirportLabel(
                    code:
                        widget.flight.toAirport,
                    city:
                        _destinationCity,
                    alignEnd: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AirportLabel extends StatelessWidget {
  final String code;
  final String city;
  final bool alignEnd;

  const _AirportLabel({
    required this.code,
    required this.city,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.navIcon,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          city,
          style: TextStyle(
            fontSize: 12,
            color:
                Colors.black.withOpacity(.55),
          ),
        ),
      ],
    );
  }
}

class _StopMarker extends StatelessWidget {
  final String code;

  const _StopMarker({required this.code});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.navIcon, width: 2),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          code,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.navIcon,
          ),
        ),
      ],
    );
  }
}

class _ItineraryMarker extends StatelessWidget {
  final String name;

  const _ItineraryMarker({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.15),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: AppColors.navIcon,
            ),
          ),
        ),
      ],
    );
  }
}

class _DotMarker extends StatelessWidget {
  const _DotMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navIcon,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white,
          width: 2,
        ),
      ),
    );
  }
}