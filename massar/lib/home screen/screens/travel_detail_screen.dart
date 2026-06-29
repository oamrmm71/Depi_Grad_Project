import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom widgets/bottom_nav_glass.dart';
import 'package:massar/custom widgets/flight_path_connector.dart';
import 'package:massar/custom widgets/glass_button.dart';
import 'package:massar/custom widgets/glass_container.dart';
import 'package:massar/custom widgets/glow_circle.dart';

import '../models/trip_model.dart';

class TravelDetailScreen extends StatelessWidget {
  final TripModel trip;

  const TravelDetailScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF00287C),
                  Color(0xFF01253D),
                  Color(0xFF00133F),
                ],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),

          // Glow
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.9, 0.9),
                radius: 1.15,
                colors: [
                  const Color(0xFFBAD1FF).withOpacity(0.28),
                  const Color(0xFFBAD1FF).withOpacity(0.08),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),

          // Scrollable content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 74,
                left: 24,
                right: 20,
                bottom: 120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TRIP',
                            style: GoogleFonts.poppins(
                              fontSize: 42,
                              fontWeight: FontWeight.w200,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              height: 0.9,
                            ),
                          ),
                          Text(
                            'DETAILS',
                            style: GoogleFonts.poppins(
                              fontSize: 44,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GlassButton(
                            width: 140,
                            height: 52,
                            borderRadius: 50,
                            child: Text(
                              'Travel Notes',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {},
                          ),
                          GlassButton(
                            width: 52,
                            height: 52,
                            borderRadius: 50,
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 26,
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  Text(
                    '${trip.departureDate} to ${trip.arrivalDate}',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),

                  // Plane + content stack
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 190),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: GlassContainer(
                                width: double.infinity,
                                height: 180,
                                borderRadius: 40,
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GlowCircle(
                                              radius: 10,
                                              color: const Color.fromARGB(
                                                69,
                                                92,
                                                0,
                                                28,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Takeoff Flight',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          trip.flightCode,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 30.0,
                                      ),
                                      child: Text(
                                        trip.flightCompany,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _locationWidget(
                                          city: trip.takeoffCity,
                                          code: trip.takeoffAirport,
                                          time: trip.takeoffTime ?? "N/A",
                                        ),

                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            GlowCircle(
                                              radius: 40,
                                              color: const Color.fromARGB(
                                                69,
                                                255,
                                                216,
                                                228,
                                              ),
                                            ),
                                            Transform.rotate(
                                              angle: 1.57,
                                              child: const Icon(
                                                Icons.airplanemode_active,
                                                color: Color.fromARGB(
                                                  255,
                                                  0,
                                                  9,
                                                  46,
                                                ),
                                                size: 28,
                                              ),
                                            ),
                                          ],
                                        ),

                                        _locationWidget(
                                          city: trip.destinationCity,
                                          code: trip.destinationAirport,
                                          time: trip.destinationTime ?? "N/A",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            GlassContainer(
                              width: double.infinity,
                              height: 54,
                              borderRadius: 20,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Economy class',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '3000 EGP',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Center(
                              child: FlightPathConnector(
                                circleRadius: 6,
                                lineHeight: 60,
                                lineWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),

                      
                          ],
                        ),
                      ),

                      // Plane in front
                      Transform.translate(
                        offset: const Offset(-24, -40),
                        child: Image.asset(
                          'lib/assets/trip_details_plane.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Fixed bottom nav
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: BottomNavGlass(
              selectedIndex: 0,
              onTap: (index) {
                print(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget _locationWidget({
    required String city,
    required String code,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          city,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            height: 0.8,
          ),
        ),
        Text(
          code,
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          time,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            height: 0.8,
          ),
        ),
      ],
    );
  }
}
