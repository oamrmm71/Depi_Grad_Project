import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/routes.dart';
import 'package:massar/theme/app_colors.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final contentWidth = size.width * 0.74;
    final titleFont = (size.width * 0.090).clamp(30.0, 42.0).toDouble();
    final bodyFont = (size.width * 0.040).clamp(15.0, 18.0).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFF01253D),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
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
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.02),
                  child: Image.asset(
                    'lib/assets/plane_page3.png',
                    width: size.width * 1.18,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.52),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
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
                        const SizedBox(height: 12),
                        SizedBox(
                          width: contentWidth,
                          child: Text(
                            'Not sure where to go next? We help you explore destinations that match your mood, your budget, and your travel style. Whether you\'re craving a peaceful escape or a busy city experience, your journey starts here.',
                          style: GoogleFonts.poppins(
                            fontSize: bodyFont,
                            fontWeight: FontWeight.w300,
                            height: 1.08,
                            color: AppColors.white,
                          ),
                        ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withValues(alpha: 0.18),
                                  Colors.white.withValues(alpha: 0.10),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.18),
                                width: 1,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(28),
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    Routes.onboarding4,
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    'there\'s more?',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onboardingText,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
