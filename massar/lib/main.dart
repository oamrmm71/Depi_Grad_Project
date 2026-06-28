import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:massar/home%20screen/cubits/trip_cubit.dart';
import 'splash_screen.dart';
import 'home screen/services/trip_service.dart';
import 'home screen/repositories/trip_repository.dart';

void main() {
  final tripService = TripService();
  final tripRepository = TripRepository(tripService);

  runApp(
    BlocProvider(
      create: (_) => TripCubit(tripRepository)
        ..fetchTrip(
          origin: "CAI",
          destination: "DOH",
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