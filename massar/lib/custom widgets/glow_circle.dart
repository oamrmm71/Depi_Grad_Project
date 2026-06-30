import 'package:flutter/material.dart';
import 'package:massar/theme/app_colors.dart';

class GlowCircle extends StatelessWidget {
  final double radius;
  final Color color;

  const GlowCircle({
    super.key,
    required this.radius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.9), // center
            color.withOpacity(0.5),
            color.withOpacity(0.2),
            AppColors.transparent, // faded edge
          ],
          stops: const [0.0, 0.35, 0.7, 1.0],
        ),
      ),
    );
  }
}