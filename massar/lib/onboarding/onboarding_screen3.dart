import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom%20widgets/glass_button.dart';
import 'package:massar/routes.dart';
import 'package:massar/theme/app_colors.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleFont = (size.width * 0.090).clamp(30.0, 42.0).toDouble();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A2A43),
            Color(0xFF01253D),
            Color(0xFF002A5B),
          ],
          stops: [0.0, 0.63, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: size.height * 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Image.asset(
                  'lib/assets/plane_page3.png',
                  width: size.width * 1.18,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              left: 28,
              right: 28,
              top: size.height * 0.48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover Your\nNext Adventure',
                    style: GoogleFonts.poppins(
                      fontSize: titleFont,
                      fontWeight: FontWeight.w700,
                      height: 1.02,
                      color: AppColors.onboardingText,
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: size.width * 0.9,
                    child: Text(
                      'Not sure where to go next? We help you explore destinations that match your mood, your budget, and your travel style. Whether you\'re craving a peaceful escape or a busy city experience, your journey starts here.',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                        height: 1.2,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 40,
              child: GlassButton(
                text: "there's more?",
                width: double.infinity,
                height: 52,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.onboarding4,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
