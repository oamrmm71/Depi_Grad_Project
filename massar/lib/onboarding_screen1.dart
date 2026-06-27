import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1.0, -0.6),
          end: Alignment(-1.0, 0.2),
          stops: [0.0, 0.22, 0.44, 1.0],
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
            Positioned(
              top: 420,
              left: 40,
              child: Text(
                'Explore Trips!',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffF5F5F5),
                ),
              ),
            ),
            Positioned(
              top: 488,
              left: 40,
              child: Text(
                'Your journey to seamless\ntravel begins here.',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w200,
                  color: Color(0xffF5F5F5),
                   height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
