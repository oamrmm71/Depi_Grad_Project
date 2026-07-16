import 'package:flutter/material.dart';
import 'package:massar/theme/app_colors.dart';

class ProfileBackground extends StatelessWidget {
  const ProfileBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                AppColors.screenBgGrad1,
                AppColors.screenBgGrad2,
                AppColors.screenBgGrad3,
              ],
              stops: [
                0.0,
                0.45,
                1.0,
              ],
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.9, 0.9),
              radius: 1.15,
              colors: [
                AppColors.glowHigh,
                AppColors.glowLow,
                AppColors.transparent,
              ],
              stops: const [
                0.0,
                0.55,
                1.0,
              ],
            ),
          ),
        ),
      ],
    );
  }
}