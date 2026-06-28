import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom%20widgets/bottom_nav_glass.dart';
import 'package:massar/custom%20widgets/glass_button.dart';
import 'package:massar/custom%20widgets/glass_container.dart';

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
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Image.asset(
              'lib/assets/trip_details_plane.png',
              height: 440,
              fit: BoxFit.contain,
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
                GlassContainer(
                  width: 320,
                  height: 180,
                  borderRadius: 40,
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [Text("Takeoff Flight")]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
