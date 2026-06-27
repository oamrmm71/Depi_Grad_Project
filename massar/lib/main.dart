import 'package:flutter/material.dart';
import 'onboarding1.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/onboarding1',

      routes: {
        '/onboarding1': (context) => const Onboarding1(),
      },
    );
  }
}