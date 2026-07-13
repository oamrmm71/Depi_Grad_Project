import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/onboarding/onboarding_screen7.dart';
import 'package:massar/theme/app_colors.dart';

class OnboardingScreen6 extends StatelessWidget {
  const OnboardingScreen6({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              const SizedBox(height: 18),

              Text(
                "With Massar\nYou can:",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navIcon,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 45),

              const FeatureItem(
                image: "lib/assets/time sand.png",
                text:
                    "Plan your journey\ntimeline with smart\nitineraries.",
                rotation: -0.08,
                imageLeft: true,
              ),

              const SizedBox(height: 30),

              const FeatureItem(
                image: "lib/assets/maps.png",
                text:
                    "Plan your journey\ntimeline with smart\nitineraries.",
                rotation: 0.08,
                imageLeft: false,
              ),

              const SizedBox(height: 30),

              const FeatureItem(
                image: "lib/assets/tower.png",
                text:
                    "Discover iconic\nlandmarks and\nunforgettable\nexperiences.",
                rotation: -0.05,
                imageLeft: true,
              ),

              const SizedBox(height: 30),

              const FeatureItem(
                image: "lib/assets/clock.png",
                text:
                    "Stay on track with live\ntrip schedules and\nreminders.",
                rotation: 0,
                imageLeft: false,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen7(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navIcon,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Lets start..",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String image;
  final String text;
  final double rotation;
  final bool imageLeft;

  const FeatureItem({
    super.key,
    required this.image,
    required this.text,
    required this.rotation,
    required this.imageLeft,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = SizedBox(
      width: 72,
      height: 72,
      child: Image.asset(
        image,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.broken_image,
            size: 40,
            color: Colors.grey,
          );
        },
      ),
    );

    final textWidget = Transform.rotate(
      angle: rotation,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.flightGlow,
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
                child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.navIcon,
            height: 1.1,
          ),
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: imageLeft
          ? [
              imageWidget,
              const SizedBox(width: 10),
              Flexible(
                child: textWidget,
              ),
            ]
          : [
              Flexible(
                child: textWidget,
              ),
              const SizedBox(width: 10),
              imageWidget,
            ],
    );
  }
}