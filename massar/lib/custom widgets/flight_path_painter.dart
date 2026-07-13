import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class FlightPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    path.moveTo(size.width * .20, size.height * .22);

    path.quadraticBezierTo(
      size.width * .70,
      size.height * .35,
      size.width * .80,
      size.height * .5,
    );

    canvas.drawPath(
      dashPath(path, dashArray: CircularIntervalList([12, 10])),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}