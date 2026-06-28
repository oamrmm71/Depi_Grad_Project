import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom%20widgets/bottom_nav_glass.dart';
import 'package:massar/custom%20widgets/flight_path_connector.dart';
import 'package:massar/custom%20widgets/glass_button.dart';
import 'package:massar/custom%20widgets/glass_container.dart';
import 'package:massar/custom%20widgets/glow_circle.dart';

class TravelDetailScreen extends StatelessWidget {
  const TravelDetailScreen({super.key});

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

          Padding(
            padding: const EdgeInsets.only(top: 74, left: 24, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  '13/7/2026 to 20/7/2026',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 220),
                SizedBox(
                  width: double.infinity,
                  child: GlassContainer(
                    width: double.infinity,
                    height: 180,
                    borderRadius: 40,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GlowCircle(
                                  radius: 10,
                                  color: const Color.fromARGB(69, 92, 0, 28),
                                ),
                                SizedBox(width: 10),
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
                              'AF AA312',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text(
                            'Qatar Airways',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cairo',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    height: 0.8,
                                  ),
                                ),
                                Text(
                                  'CAI',
                                  style: GoogleFonts.poppins(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '10:30 AM',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    height: 0.8,
                                  ),
                                ),
                              ],
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
                                  angle: 1.57, // 90 degrees
                                  child: Icon(
                                    Icons.airplanemode_active,
                                    color: const Color.fromARGB(255, 0, 9, 46),
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cairo',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    height: 0.8,
                                  ),
                                ),
                                Text(
                                  'CAI',
                                  style: GoogleFonts.poppins(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '10:30 AM',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    height: 0.8,
                                  ),
                                ),
                              ],
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
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                SizedBox(height: 20),
                Center(
                  child: FlightPathConnector(
                    circleRadius: 6,
                    lineHeight: 60,
                    lineWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            child: Image.asset(
              'lib/assets/trip_details_plane.png',
              height: 440,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
