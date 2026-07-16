import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/routes.dart';
import 'package:massar/theme/app_colors.dart';

class OnboardingScreen5 extends StatelessWidget {
  const OnboardingScreen5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            final bool isDesktop = width >= 900;
            final bool isTablet = width >= 600;

            final imageHeight = isDesktop
                ? height * .50
                : isTablet
                    ? height * .42
                    : height * .38;

            final textWidth = isDesktop
                ? 520.0
                : isTablet
                    ? 420.0
                    : width * .72;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * .05,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: imageHeight,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: imageHeight * .08,
                              right: width * .08,
                              child: Image.asset(
                                'lib/assets/boarding 2.png',
                                width: width * .65,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Positioned(
                              top: imageHeight * .42,
                              left: width * .15,
                              child: Image.asset(
                                'lib/assets/boarding 1.png',
                                width: width * .58,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      _FeatureRow(
                        icon: Transform.rotate(
                          angle: -45 * math.pi / 180,
                          child: Image.asset(
                            'lib/assets/ticket.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        text:
                            'Tailored recommendations that match your style, making every trip uniquely yours.',
                        maxWidth: textWidth,
                      ),

                      const SizedBox(height: 24),

                      _FeatureRow(
                        icon: Image.asset(
                          'lib/assets/stopwatch.png',
                          width: 40,
                          height: 40,
                        ),
                        text:
                            'Explore hidden gems and create meaningful travel experiences with ease.',
                        maxWidth: textWidth,
                      ),

                      SizedBox(
                        height: isDesktop ? 60 : 40,
                      ),

                      SizedBox(
                        width: isDesktop ? 450 : double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              Routes.onboarding6,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navIcon,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            minimumSize: const Size.fromHeight(55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "what else?",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final Widget icon;
  final String text;
  final double maxWidth;

  const _FeatureRow({
    required this.icon,
    required this.text,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth + 70),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}