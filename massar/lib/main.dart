import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:massar/home%20screen/cubits/trip_cubit.dart';
import 'package:massar/home%20screen/repositories/trip_repository.dart';
import 'package:massar/home%20screen/screens/home_screen.dart';
import 'package:massar/home%20screen/services/country_service.dart';
import 'package:massar/home%20screen/services/flight_service.dart';
import 'package:massar/home%20screen/services/groq_service.dart';
import 'package:massar/home%20screen/services/image_service.dart';
import 'package:massar/home%20screen/services/trip_service.dart';
import 'package:massar/onboarding/onboarding_screen2.dart';
import 'package:massar/onboarding/onboarding_screen1.dart';
import 'package:massar/onboarding/onboarding_screen6.dart';
import 'package:massar/onboarding/onboarding_screen7.dart';
import 'package:massar/auth/login.dart';
import 'package:massar/Profile/profile_screen.dart';
import 'package:massar/flights%20screen/screens/flights_screen.dart';

import 'routes.dart';
import 'splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final countryService = CountryService();

  final flightService = FlightService(
    countryService: countryService,
  );

  final groqService = GroqService();

  final imageService = ImageService();

  final tripService = TripService(
    flightService: flightService,
    groqService: groqService,
    imageService: imageService,
    countryService: countryService,
  );

  final tripRepository = TripRepository(tripService);

  runApp(
    BlocProvider(
      create: (_) => TripCubit(tripRepository)
        ..fetchTrips(
          origin: "CAI",
          budget: 1000000,
        ),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Massar',
      initialRoute: Routes.splash,

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.splash:
            return MaterialPageRoute(
              builder: (_) => const SplashScreen(),
            );

          case Routes.onboarding1:
            return MaterialPageRoute(
              builder: (_) => const Onboarding1(),
            );

          case Routes.onboarding2:
            return MaterialPageRoute(
              builder: (_) => const Onboarding2(),
            );

          case Routes.onboarding6:
            return MaterialPageRoute(
              builder: (_) => const OnboardingScreen6(),
            );

          case Routes.onboarding7:
            return MaterialPageRoute(
              builder: (_) => const OnboardingScreen7(),
            );

          case Routes.login:
            return MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            );

          case Routes.home:
            return MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            );

          case Routes.flights:
            return MaterialPageRoute(
              builder: (_) => const FlightsScreen(),
            );

          case Routes.profile:
            return MaterialPageRoute(
              builder: (_) => const ProfileScreen(),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text(
                    'No route defined for ${settings.name}',
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}