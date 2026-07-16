import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../home screen/services/country_service.dart';
import '../../home screen/services/flight_service.dart';
import '../models/flight_model.dart';

class FlightRouteScreen extends StatefulWidget {
  final FlightModel flight;

  const FlightRouteScreen({
    super.key,
    required this.flight,
  });

  @override
  State<FlightRouteScreen> createState() => _FlightRouteScreenState();
}

class _FlightRouteScreenState extends State<FlightRouteScreen> {
  late final FlightService _flightService;

  bool _loading = true;
  String? _error;

  late LatLng _origin;
  late LatLng _destination;

  String _originCity = '';
  String _destinationCity = '';

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
      final originData = await _flightService.getAirportDetails(
        widget.flight.fromAirport,
      );

      final destinationData = await _flightService.getAirportDetails(
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

      _originCity = originData["cityName"];
      _destinationCity = destinationData["cityName"];

      if (mounted) {
        setState(() {
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
        appBar: AppBar(),
        body: Center(
          child: Text(_error!),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCameraFit: CameraFit.bounds(
                bounds: LatLngBounds.fromPoints([
                  _origin,
                  _destination,
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
                userAgentPackageName: 'com.yourcompany.massar',
              ),

              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [
                      _origin,
                      _destination,
                    ],
                    strokeWidth: 3,
                    color: const Color(0xff16305B),
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
                      color: Color(0xff16305B),
                      size: 28,
                    ),
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
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TRIP",
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: 2,
                          color: Colors.black.withOpacity(.45),
                        ),
                      ),
                      const Text(
                        "ROUTE",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff16305B),
                        ),
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                        color: Color(0xff16305B),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  _AirportLabel(
                    code: widget.flight.fromAirport,
                    city: _originCity,
                  ),
                  const Icon(
                    Icons.flight,
                    color: Color(0xff16305B),
                    size: 20,
                  ),
                  _AirportLabel(
                    code: widget.flight.toAirport,
                    city: _destinationCity,
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
      crossAxisAlignment:
          alignEnd
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xff16305B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          city,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black.withOpacity(.55),
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
        color: const Color(0xff16305B),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
    );
  }
}