import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom%20widgets/glass_button.dart';
import 'package:massar/onboarding/onboarding_screen2.dart';
import 'package:massar/theme/app_colors.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1.0, -0.6),
          end: Alignment(-1.0, 0.2),
          stops: [0.0, 0.22, 0.44, 1.0],
          colors: [
            AppColors.onboardingGrad1,
            AppColors.onboardingGrad2,
            AppColors.onboardingGrad3,
            AppColors.onboardingGrad4,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: -12,
              child: Image.asset(
                'lib/assets/plane_onboarding1.png',
                height: 720,
                fit: BoxFit.fitHeight,
              ),
            ),
            Positioned(
              top: 420,
              left: 40,
              child: Text(
                'Explore Trips!',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onboardingText,
                ),
              ),
            ),
            Positioned(
              top: 488,
              left: 40,
              child: Text(
                'Your journey to seamless\ntravel begins here.',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w200,
                  color: AppColors.onboardingText,
                  height: 1.2,
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: GlassButton(
                text: 'Hi!',
                width: double.infinity,
                height: 54,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Onboarding2()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


}