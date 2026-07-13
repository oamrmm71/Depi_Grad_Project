import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/home%20screen/screens/home_screen.dart';
import 'package:massar/theme/app_colors.dart';

class OnboardingScreen7 extends StatelessWidget {
  const OnboardingScreen7({super.key});

  void _goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final maxContentWidth = size.width > 700 ? 650.0 : size.width;

    final titleSize = (size.width * 0.065).clamp(24.0, 32.0);
    final bodySize = (size.width * 0.036).clamp(14.0, 17.0);
    final buttonFont = (size.width * 0.048).clamp(18.0, 22.0);

    final buttonHeight = (size.height * .075).clamp(54.0, 60.0);

    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxContentWidth,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * .06,
              ),
              child: Column(
                children: [
                  const Spacer(),

                  Text(
                    "Airplane Mode",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navIcon,
                    ),
                  ),

                  SizedBox(height: size.height * .015),

                  Text(
                    "Airplane Mode saves battery,\navoids roaming, and keeps\nyour trip stress-free.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: bodySize,
                      color: AppColors.navIcon.withValues(alpha: .65),
                      height: 1.4,
                    ),
                  ),

                  const Spacer(),

                  const AirplaneIllustration(),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: () => _goHome(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navIcon,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Allow",
                        style: GoogleFonts.poppins(
                          fontSize: buttonFont,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * .02),

                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: () => _goHome(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.navIcon,
                        elevation: 5,
                        shadowColor: AppColors.flightGlow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Skip",
                        style: GoogleFonts.poppins(
                          fontSize: buttonFont,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navIcon,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * .03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AirplaneIllustration extends StatelessWidget {
  const AirplaneIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final circleSize = (width * .70).clamp(240.0, 330.0);
    final outerCircle = circleSize;
    final innerCircle = circleSize * .54;

    final centerImage = circleSize * .31;
    final radius = circleSize * .39;
    final iconSize = circleSize * .14;

    return SizedBox(
      width: outerCircle,
      height: outerCircle,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: outerCircle,
            height: outerCircle,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: .45),
              boxShadow: [
                BoxShadow(
                  color: AppColors.flightGlow,
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),

          Container(
            width: innerCircle,
            height: innerCircle,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                "lib/assets/glass.png",
                width: centerImage,
                fit: BoxFit.contain,
              ),
            ),
          ),
                    _circleIcon(
            asset: "lib/assets/youtube.png",
            angle: 0,
            radius: radius,
            iconSize: iconSize,
          ),

          _circleIcon(
            asset: "lib/assets/tiktok.png",
            angle: 45,
            radius: radius,
            iconSize: iconSize,
          ),

          _circleIcon(
            asset: "lib/assets/instagram.png",
            angle: 90,
            radius: radius,
            iconSize: iconSize,
          ),

          _circleIcon(
            asset: "lib/assets/call.png",
            angle: 135,
            radius: radius,
            iconSize: iconSize,
          ),

          _circleIcon(
            asset: "lib/assets/snapchat.png",
            angle: 180,
            radius: radius,
            iconSize: iconSize,
          ),

          _circleIcon(
            asset: "lib/assets/whatsapp.png",
            angle: 225,
            radius: radius,
            iconSize: iconSize,
          ),

          _circleIcon(
            asset: "lib/assets/facebook.png",
            angle: 270,
            radius: radius,
            iconSize: iconSize,
          ),

          _circleIcon(
            asset: "lib/assets/facetime.png",
            angle: 315,
            radius: radius,
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }

  Widget _circleIcon({
    required String asset,
    required double angle,
    required double radius,
    required double iconSize,
  }) {
    final radians = angle * math.pi / 180;

    return Transform.translate(
      offset: Offset(
        radius * math.cos(radians),
        radius * math.sin(radians),
      ),
      child: SizedBox(
        width: iconSize,
        height: iconSize,
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) {
            return Icon(
              Icons.image_not_supported_outlined,
              size: iconSize * .8,
              color: Colors.grey,
            );
          },
        ),
      ),
    );
  }
}