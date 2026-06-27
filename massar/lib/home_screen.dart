import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom%20widgets/glass_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

          // Top row
          Positioned(
            top: 70,
            left: 24,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: ClipOval(
                    child: Image.asset(
                      'lib/assets/profile.png',
                      width: 98,
                      height: 98,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Row(
                  children: [
                    GlassButton(
                      width: 60,
                      height: 60,
                      borderRadius: 50,
                      child: const Icon(
                        Icons.notifications_on,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () {},
                    ),
                    SizedBox(width: 2),
                    GlassButton(
                      width: 60,
                      height: 60,
                      borderRadius: 50,
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 150,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore The',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w200,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  'WORLD WITH AI',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 265,
            left: 20,
            right: 0,
            child: SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GlassButton(
                    width: 52,
                    height: 52,
                    borderRadius: 50,
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 24,
                    ),
                    onTap: () {},
                  ),

                  const SizedBox(width: 8),

                  GlassButton(
                    width: 52,
                    height: 52,
                    borderRadius: 50,
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                      size: 22,
                    ),
                    onTap: () {},
                  ),

                  const SizedBox(width: 8),

                  GlassButton(
                    text: 'Tour Package',
                    width: 135,
                    height: 52,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    borderRadius: 30,
                    onTap: () {},
                  ),

                  const SizedBox(width: 8),

                  GlassButton(
                    text: 'Budget Package',
                    width: 150,
                    height: 52,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    borderRadius: 30,
                    onTap: () {},
                  ),

                  const SizedBox(width: 8),

                  GlassButton(
                    text: 'Trip Package',
                    width: 130,
                    height: 52,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    borderRadius: 30,
                    onTap: () {},
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
