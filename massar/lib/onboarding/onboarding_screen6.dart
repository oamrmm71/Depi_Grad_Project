import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/onboarding/onboarding_screen7.dart';
import 'package:massar/theme/app_colors.dart';

class OnboardingScreen6 extends StatelessWidget {
  const OnboardingScreen6({super.key});

  static const double horizontalPadding = 80;
  static const double featureScale = 1.5;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final buttonHeight = (size.height * 0.075).clamp(54.0, 60.0);

    const features = [
      _FeatureData(
        image: "lib/assets/time sand.png",
        text: "Plan your journey\ntimeline with smart\nitineraries.",
        rotation: -0.08,
        imageLeft: true,
      ),
      _FeatureData(
        image: "lib/assets/maps.png",
        text: "Plan your journey\ntimeline with smart\nitineraries.",
        rotation: 0.08,
        imageLeft: false,
      ),
      _FeatureData(
        image: "lib/assets/tower.png",
        text: "Discover iconic\nlandmarks and\nunforgettable\nexperiences.",
        rotation: -0.05,
        imageLeft: true,
      ),
      _FeatureData(
        image: "lib/assets/clock.png",
        text: "Stay on track with live\ntrip schedules and\nreminders.",
        rotation: 0,
        imageLeft: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    Text(
                      "With Massar\nYou can:",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navIcon,
                        height: 1.1,
                      ),
                    ),

                    const Spacer(),

                    ...features.map(
                      (feature) => Column(
                        children: [
                          Transform.scale(
                            scale: featureScale,
                            child: FeatureItem(
                              image: feature.image,
                              text: feature.text,
                              rotation: feature.rotation,
                              imageLeft: feature.imageLeft,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            StartButton(
              height: buttonHeight,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OnboardingScreen7(),
                  ),
                );
              },
            ),

            SizedBox(height: size.height * 0.025),
          ],
        ),
      ),
    );
  }
}


class _FeatureData {
  final String image;
  final String text;
  final double rotation;
  final bool imageLeft;

  const _FeatureData({
    required this.image,
    required this.text,
    required this.rotation,
    required this.imageLeft,
  });
}


class StartButton extends StatelessWidget {
  final double height;
  final VoidCallback onPressed;

  const StartButton({
    super.key,
    required this.height,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
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
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
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
    final width = MediaQuery.of(context).size.width;

    final imageSize = (width * 0.16).clamp(60.0, 80.0);
    final textFont = (width * 0.032).clamp(13.0, 16.0);

    final imageWidget = SizedBox(
      width: imageSize,
      height: imageSize,
      child: Image.asset(
        image,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return const Icon(
            Icons.broken_image,
            color: Colors.grey,
          );
        },
      ),
    );

    final baseTextStyle = GoogleFonts.poppins(
      fontSize: textFont,
      fontWeight: FontWeight.w700,
      height: 1.15,
    );

    final textWidget = Transform.rotate(
      angle: rotation,
      child: Stack(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: baseTextStyle.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
                ..strokeJoin = StrokeJoin.round
                ..color = AppColors.white,
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: baseTextStyle.copyWith(
              color: AppColors.navIcon,
            ),
          ),
        ],
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: imageLeft
          ? [
              imageWidget,
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: textWidget,
                ),
              ),
            ]
          : [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: textWidget,
                ),
              ),
              imageWidget,
            ],
    );
  }
}