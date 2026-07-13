import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/theme/app_colors.dart';
import 'package:massar/routes.dart';
import 'package:massar/custom widgets/flight_path_painter.dart';

class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.splashBg,
        body: Material(
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF01253D),

                          AppColors.splashBg.withOpacity(0.0),
                        ],
                        stops: [.55, 1],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Image.asset(
                  'lib/assets/black_map.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(child: CustomPaint(painter: FlightPathPainter())),
              Positioned(
                left: screenWidth * .18,
                top: screenHeight * .20,
                child: _buildPin(),
              ),

              Positioned(
                right: screenWidth * .17,
                top: screenHeight * .5,
                child: _buildPin(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24),
                      Text(
                        'Create and organize your full itinerary. Save places you want to visit. Keep flights, stays, and plans in one place. Access everything anytime, anywhere.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                          
                          color: const Color(0xFF01253D),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Stressless Planning',
                        style: GoogleFonts.poppins(
                          
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              Routes.onboarding5,
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
                            "Continue",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPin() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 0.8,
          child: Image.asset('lib/assets/Ellipse 1.png', width: 24, height: 24),
        ),
        Image.asset('lib/assets/Ellipse 2.png', width: 12, height: 12),
      ],
    );
  }
}

