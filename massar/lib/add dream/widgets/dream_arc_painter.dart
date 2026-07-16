import 'package:flutter/material.dart';
import 'package:massar/theme/app_colors.dart';

class DreamArcPainter extends CustomPainter {
  const DreamArcPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final rect = Rect.fromCircle(
      center: Offset(-size.width * 0.42, size.height * 0.42),
      radius: size.width * 0.82,
    );

    canvas.drawArc(rect, -1.45, 3.35, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
