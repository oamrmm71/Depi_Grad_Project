import 'package:flutter/material.dart';

class FlightPathConnector extends StatelessWidget {
  final double circleRadius;
  final double lineHeight;
  final double lineWidth;
  final Color color;

  const FlightPathConnector({
    super.key,
    this.circleRadius = 10,
    this.lineHeight = 50,
    this.lineWidth = 2,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top circle
        Container(
          width: circleRadius * 2,
          height: circleRadius * 2,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        // Line
        Container(
          width: lineWidth,
          height: lineHeight,
          color: color.withOpacity(0.8),
        ),

        // Bottom circle
        Container(
          width: circleRadius * 2,
          height: circleRadius * 2,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}