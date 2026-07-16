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
          begin: Alignment(-1.0, -0.6),
          end: Alignment(1.0, 0.2),
          stops: [0.0, 0.05, 0.3, 1.0],
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
                top: -10 ,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.85,
                  child: Image.asset(
                    'lib/assets/map.png',
                    width: size.width,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),

              Positioned(
                bottom: size.height * 0,
                right: -size.width * 0.005,
                child: Transform.rotate(
                  angle: 0.01,
                  child: Image.asset(
                    'lib/assets/plan.png',
                    width: size.width * 0.9,
                    fit: BoxFit.contain,
                  ),
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
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Want to plan',
                          ),
                          
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        children: [
                          const TextSpan(
                            text: 'your next trip',
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Image.asset(
                                'lib/assets/Frame.png',
                                height: 38,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Press anywhere to continue',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
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
