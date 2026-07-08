import 'package:flutter/material.dart';
import 'package:massar/theme/app_colors.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

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

              const Text(
                "With Massar\nYou can:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navIcon,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 45),

              const FeatureItem(
                image: "assets/time sand.png",
                text:
                    "Plan your journey\ntimeline with smart\nitineraries.",
                rotation: -0.08,
                imageLeft: true,
              ),

              const SizedBox(height: 30),

              const FeatureItem(
                image: "assets/maps.png",
                text:
                    "Plan your journey\ntimeline with smart\nitineraries.",
                rotation: 0.08,
                imageLeft: false,
              ),

              const SizedBox(height: 30),

              const FeatureItem(
                image: "assets/tower.png",
                text:
                    "Discover iconic\nlandmarks and\nunforgettable\nexperiences.",
                rotation: -0.05,
                imageLeft: true,
              ),

              const SizedBox(height: 30),

              const FeatureItem(
                image: "assets/clock.png",
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navIcon,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Lets start..",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
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
          style: const TextStyle(
            fontSize: 14,
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: AppColors.navIcon,
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
              Flexible(child: textWidget),
            ]
          : [
              Flexible(child: textWidget),
              const SizedBox(width: 10),
              imageWidget,
            ],
    );
  }
}