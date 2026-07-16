import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/theme/app_colors.dart';
import 'package:massar/custom%20widgets/bottom_nav_glass.dart';
import 'package:massar/custom%20widgets/glass_container.dart';
import 'package:massar/flights%20screen/cubits/flight_cubit.dart';
import 'package:massar/flights%20screen/cubits/flight_state.dart';
import 'package:massar/flights%20screen/models/flight_model.dart';

class FlightsScreen extends StatelessWidget {
  const FlightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlightCubit(),
      child: const _FlightsScreenBody(),
    );
  }
}

class _FlightsScreenBody extends StatelessWidget {
  const _FlightsScreenBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.screenBgGrad1,
                  AppColors.screenBgGrad2,
                  AppColors.screenBgGrad3,
                ],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.9, 0.9),
                radius: 1.15,
                colors: [
                  AppColors.glowHigh,
                  AppColors.glowLow,
                  AppColors.transparent,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 230,
                      width: double.infinity,
                      child: Image.asset(
                        'lib/assets/flight_hero.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 24,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Text(
                            'YOUR',
                            style: GoogleFonts.poppins(
                              color: AppColors.white,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            'FLIGHTS',
                            style: GoogleFonts.poppins(
                              color: AppColors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: BlocBuilder<FlightCubit, FlightState>(
                    builder: (context, state) {
                      if (state is FlightLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                          ),
                        );
                      }
                      if (state is FlightError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: AppColors.white),
                          ),
                        );
                      }
                      if (state is FlightLoaded) {
                        if (state.flights.isEmpty) {
                          return const Center(
                            child: Text(
                              'No flights yet',
                              style: TextStyle(color: AppColors.white),
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          itemCount: state.flights.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            return _FlightCard(flight: state.flights[index]);
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: BottomNavGlass(currentIndex: 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlightCard extends StatelessWidget {
  final FlightModel flight;

  const _FlightCard({required this.flight});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 22,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${flight.flightType}\n${flight.flightCompany}',
                style: GoogleFonts.poppins(
                  color: AppColors.whiteDim,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    flight.date,
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    flight.flightCode,
                    style: GoogleFonts.poppins(
                      color: AppColors.whiteDim,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                flight.fromCountry,
                style: GoogleFonts.poppins(
                  color: AppColors.whiteDim,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                flight.toCountry,
                style: GoogleFonts.poppins(
                  color: AppColors.whiteDim,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flight.fromAirport,
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    flight.fromTime,
                    style: GoogleFonts.poppins(
                      color: AppColors.whiteDim,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.flight, color: AppColors.white, size: 26),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    flight.toAirport,
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    flight.toTime,
                    style: GoogleFonts.poppins(
                      color: AppColors.whiteDim,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}