import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/routes.dart';
import 'package:massar/theme/app_colors.dart';

class Onboarding2 extends StatefulWidget {
  const Onboarding2({super.key});

  @override
  State<Onboarding2> createState() => _Onboarding2State();
}

class _Onboarding2State extends State<Onboarding2> {
  final int currentPage = 0;
  final int pageCount = 3;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pushReplacementNamed(
            context,
            Routes.onboarding3,
          );
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned(
                top: -size.height * 0.02,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.55,
                  child: Image.asset(
                    'lib/assets/map.png',
                    width: size.width,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),

              Positioned(
                bottom: size.height * 0.001,
                right: -size.width * 0.005,
                child: Transform.rotate(
                  angle: 0.01,
                  child: Image.asset(
                    'lib/assets/plan.png',
                    width: size.width * 0.75,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Positioned(
                right: 16,
                top: size.height * 0.5 - (pageCount * 12),
                child: Column(
                  children: List.generate(pageCount, (index) {
                    final isActive = index == currentPage;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      width: isActive ? 8 : 6,
                      height: isActive ? 8 : 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.35),
                      ),
                    );
                  }),
                ),
              ),

              Positioned(
                left: 32,
                right: 32,
                top: size.height * 0.42,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Want to plan\nyour next trip ',
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Image.asset(
                                'lib/assets/Frame.png',
                                height: 42,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      'Preparing your experience...',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
