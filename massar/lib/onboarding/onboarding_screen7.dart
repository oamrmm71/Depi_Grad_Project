import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/auth/login.dart';
import 'package:massar/theme/app_colors.dart';

class OnboardingScreen7 extends StatelessWidget {
  const OnboardingScreen7({super.key});

  void _goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;

            final maxContentWidth =
                size.width > 700 ? 650.0 : size.width;

            final titleSize =
                (size.width * .065).clamp(24.0, 34.0);

            final bodySize =
                (size.width * .036).clamp(14.0, 17.0);

            final buttonFont =
                (size.width * .048).clamp(18.0, 22.0);

            final buttonHeight =
                (size.height * .075).clamp(54.0, 60.0);

            final illustrationSize =
                size.width > 1000
                    ? 360.0
                    : size.width > 700
                        ? 320.0
                        : 260.0;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxContentWidth,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * .06,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * .05,
                          ),

                          Text(
                            "Airplane Mode",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navIcon,
                            ),
                          ),

                          SizedBox(
                            height: size.height * .01,
                          ),

                          Text(
                            "Airplane Mode saves battery, avoids\nroaming, and keeps your trip stress-free.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: bodySize,
                              fontWeight: FontWeight.w300,
                              color: AppColors.navIcon.withValues(
                                alpha: .65,
                              ),
                              height: 1.4,
                            ),
                          ),

                          SizedBox(
                            height: size.height * .04,
                          ),

                          AirplaneIllustration(
                            maxSize: illustrationSize,
                          ),

                          SizedBox(
                            height: size.height * .05,
                          ),

                          SizedBox(
                            width: double.infinity,
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: () => _goHome(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.navIcon,
                                foregroundColor:
                                    AppColors.white,
                                elevation: 0,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    30,
                                  ),
                                ),
                              ),
                              child: Text(
                                "Allow",
                                style:
                                    GoogleFonts.poppins(
                                  fontSize: buttonFont,
                                  fontWeight:
                                      FontWeight.w500,
                                  color:
                                      AppColors.white,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: size.height * .02,
                          ),

                          SizedBox(
                            width: double.infinity,
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: () => _goHome(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.white,
                                foregroundColor:
                                    AppColors.navIcon,
                                elevation: 5,
                                shadowColor:
                                    AppColors.flightGlow,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    30,
                                  ),
                                ),
                              ),
                              child: Text(
                                "Skip",
                                style:
                                    GoogleFonts.poppins(
                                  fontSize: buttonFont,
                                  fontWeight:
                                      FontWeight.w500,
                                  color:
                                      AppColors.navIcon,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: size.height * .03,
                          ),
                        ],
                      ),
                    ),
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

class AirplaneIllustration extends StatefulWidget {
  final double maxSize;

  const AirplaneIllustration({
    super.key,
    required this.maxSize,
  });

  @override
  State<AirplaneIllustration> createState() =>
      _AirplaneIllustrationState();
}
class _AirplaneIllustrationState
    extends State<AirplaneIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _icons = [
    "lib/assets/youtube.png",
    "lib/assets/tiktok.png",
    "lib/assets/instgram.png",
    "lib/assets/call.png",
    "lib/assets/snapchat.png",
    "lib/assets/whatsapp.png",
    "lib/assets/facebook.png",
    "lib/assets/facetime.png",
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = widget.maxSize;

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

          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final sweep = _controller.value * 360;

              return Stack(
                alignment: Alignment.center,
                children: [
                  for (int i = 0; i < _icons.length; i++)
                    _circleIcon(
                      asset: _icons[i],
                      angle:
                          (i * 360 / _icons.length) + sweep,
                      radius: radius,
                      iconSize: iconSize,
                    ),
                ],
              );
            },
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