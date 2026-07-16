import 'package:flutter/material.dart';
import 'package:massar/custom%20widgets/page_title.dart';

class FlightHeader extends StatelessWidget {
  const FlightHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      width: double.infinity,
      child: Stack(
        children: [
          Image.asset(
            'lib/assets/flight_hero.png',
            width: double.infinity,
            height: 230,
            fit: BoxFit.cover,
          ),

          Positioned(
            top: 24,
            left: 0,
            right: 0,
            child: Center(
              child: PageTitle(
                firstLine: "YOUR",
                secondLine: "FLIGHTS",
              ),
            ),
          ),
        ],
      ),
    );
  }
}