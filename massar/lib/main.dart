import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:massar/home%20screen/cubits/trip_cubit.dart';
import 'package:massar/home%20screen/repositories/trip_repository.dart';
import 'package:massar/home%20screen/services/country_service.dart';
import 'package:massar/home%20screen/services/flight_service.dart';
import 'package:massar/home%20screen/services/groq_service.dart';
import 'package:massar/home%20screen/services/image_service.dart';
import 'package:massar/home%20screen/services/trip_service.dart';
import 'splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final countryService = CountryService();
  final flightService = FlightService(countryService: countryService);
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
