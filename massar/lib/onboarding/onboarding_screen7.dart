import 'package:flutter/material.dart';
import 'package:massar/theme/app_colors.dart';
import 'package:massar/home%20screen/screens/home_screen.dart';
import 'dart:math' as math;

class OnboardingScreen7 extends StatelessWidget {
  const OnboardingScreen7({super.key});

  void _goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 28),

              const Text(
                "Airplane Mode",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navIcon,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Airplane Mode saves battery, avoids\nroaming, and keeps your trip stress-free.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.navIcon.withOpacity(.65),
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 42),

              const AirplaneIllustration(),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () => _goHome(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navIcon,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Allow",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () => _goHome(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.navIcon,
                    elevation: 5,
                    shadowColor: AppColors.flightGlow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class AirplaneIllustration extends StatelessWidget {
  const AirplaneIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 270,
            height: 270,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(.45),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.flightGlow,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          Container(
            width: 145,
            height: 145,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                "assets/glass.png",
                width: 85,
              ),
            ),
          ),
          _circleIcon("assets/youtube.png", 0),
          _circleIcon("assets/tiktok.png", 45),
          _circleIcon("assets/instagram.png", 90),
          _circleIcon("assets/call.png", 135),
          _circleIcon("assets/snapchat.png", 180),
          _circleIcon("assets/whatsapp.png", 225),
          _circleIcon("assets/facebook.png", 270),
          _circleIcon("assets/facetime.png", 315),
        ],
      ),
    );
  }

  Widget _circleIcon(String asset, double angle) {
    const double radius = 105;
    final radians = angle * 3.1415926535 / 180;

    return Transform.translate(
      offset: Offset(
        radius * Math.cos(radians),
        radius * Math.sin(radians),
      ),
      child: Image.asset(
        asset,
        width: 38,
        height: 38,
      ),
    );
  }
}

class Math {
  static double cos(double x) => math.cos(x);
  static double sin(double x) => math.sin(x);
}