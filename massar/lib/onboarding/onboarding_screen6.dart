import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/onboarding/onboarding_screen7.dart';
import 'package:massar/theme/app_colors.dart';

class OnboardingScreen6 extends StatelessWidget {
  const OnboardingScreen6({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final buttonHeight = (size.height * 0.075).clamp(54.0, 60.0);

    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 80,
                  right: 80,
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

                    Transform.scale(
                      scale: 1.5,
                      child: const FeatureItem(
                        image: "lib/assets/time sand.png",
                        text:
                            "Plan your journey\ntimeline with smart\nitineraries.",
                        rotation: -0.08,
                        imageLeft: true,
                      ),
                    ),

                    const Spacer(),

                    Transform.scale(
                      scale: 1.5,
                      child: const FeatureItem(
                        image: "lib/assets/maps.png",
                        text:
                            "Plan your journey\ntimeline with smart\nitineraries.",
                        rotation: 0.08,
                        imageLeft: false,
                      ),
                    ),

                    const Spacer(),

                    Transform.scale(
                      scale: 1.5,
                      child: const FeatureItem(
                        image: "lib/assets/tower.png",
                        text:
                            "Discover iconic\nlandmarks and\nunforgettable\nexperiences.",
                        rotation: -0.05,
                        imageLeft: true,
                      ),
                    ),

                    const Spacer(),

                    Transform.scale(
                      scale: 1.5,
                      child: const FeatureItem(
                        image: "lib/assets/clock.png",
                        text:
                            "Stay on track with live\ntrip schedules and\nreminders.",
                        rotation: 0,
                        imageLeft: false,
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OnboardingScreen7(),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.025),
          ],
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

    final textWidget = Transform.rotate(
      angle: rotation,
      child: Stack(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: textFont,
              fontWeight: FontWeight.w700,
              height: 1.15,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
                ..strokeJoin = StrokeJoin.round
                ..color = const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: textFont,
              fontWeight: FontWeight.w700,
              color: AppColors.navIcon,
              height: 1.15,
            ),
          ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
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
      },
    );
  }
}