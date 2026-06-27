import 'package:flutter/material.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1.0, -0.6),
          end: Alignment(-1.0, 0.2),
          stops: [0.0, 0.28, 0.55, 1.0],
          colors: [
            Color(0xFF0B63D6),
            Color(0xFF0A58BE),
            Color(0xFF00355F),
            Color(0xFF001F33),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: -12,
              child: Image.asset(
                'lib/assets/plane_onboarding1.png',
                height: 720,
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
