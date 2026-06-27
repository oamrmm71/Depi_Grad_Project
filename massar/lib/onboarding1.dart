import 'package:flutter/material.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F3),
      body: Center(
        child: Image.asset(
          'lib/assets/logo.png',
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}