import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:massar/home%20screen/cubits/trip_cubit.dart';
import 'package:massar/home%20screen/repositories/trip_repository.dart';
import 'package:massar/home%20screen/services/trip_service.dart';
import 'splash_screen.dart';

void main() {
  final tripService = TripService();
  final tripRepository = TripRepository(tripService);

  runApp(
    BlocProvider(
      create: (_) => TripCubit(tripRepository)
        ..fetchTrips(
          origin: "CAI",
          destinations: ["DOH", "DXB", "IST", "JED", "LHR"],
          budget: 8000,
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
