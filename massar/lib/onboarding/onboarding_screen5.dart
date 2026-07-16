import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/theme/app_colors.dart';
import 'package:massar/routes.dart';
import 'dart:math' as math  ;

class OnboardingScreen5 extends StatelessWidget {
  const OnboardingScreen5({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final titleFont = math.min(32.0, width * 0.06);
    final bodyFont = math.min(18.0, width * 0.045);

    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: Padding(
        padding: EdgeInsetsGeometry.only(top: 20,left:20,right:20),
        child: Column(
          children:[ SizedBox(
            width: width,
            height: height*0.6,
            child: Stack(
              alignment: AlignmentGeometry.center,
              children: [
                
                Positioned(
                  top: height*0.1,
                  right: width*0.12,
                  child: Image.asset(
                    'lib/assets/boarding 2.png',
                    width: width * 0.8,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),


          Positioned(
            top: height * 0.08,
            right: width * 0.06,
            child: Image.asset(
              'lib/assets/boarding 2.png',
              width: math.min(width * 0.85, 520),
              fit: BoxFit.contain,
            ),
          ),

          Positioned(
            top: height * 0.38,
            left: width * 0.10,
            child: Image.asset(
              'lib/assets/boarding 1.png',
              width: math.min(width * 0.7, 420),
              fit: BoxFit.contain,
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: -45 * math.pi / 180,
                          child: Image.asset(
                            'lib/assets/ticket.png',
                            width: math.min(width * 0.1, 48),
                            height: math.min(width * 0.1, 48),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tailored recommendations that match your style, making every trip uniquely yours.',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: bodyFont,
                              fontWeight: FontWeight.w300,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/stopwatch.png',
                          width: math.min(width * 0.1, 48),
                          height: math.min(width * 0.1, 48),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Explore hidden gems and create meaningful travel experiences with ease.',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: bodyFont,
                              fontWeight: FontWeight.w300,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Routes.onboarding6);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navIcon,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: SizedBox(
                          height: 52,
                          child: Center(
                            child: Text(
                              'what else?',
                              style: GoogleFonts.poppins(
                                fontSize: math.min(18.0, width * 0.045),
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
