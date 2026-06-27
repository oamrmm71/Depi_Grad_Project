import 'package:flutter/material.dart';
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
        ],
      ),
    );
  }
}
