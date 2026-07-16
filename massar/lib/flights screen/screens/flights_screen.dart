import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:massar/custom%20widgets/bottom_nav_glass.dart';
import 'package:massar/flights%20screen/cubits/flight_cubit.dart';
import 'package:massar/flights%20screen/cubits/flight_state.dart';
import 'package:massar/flights%20screen/widgets/flight_card.dart';
import 'package:massar/flights%20screen/widgets/flight_header.dart';
import 'package:massar/profile/widgets/profile_background.dart';
import 'package:massar/theme/app_colors.dart';

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
  const _FlightsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ProfileBackground(),

          SafeArea(
            child: Column(
              children: [
                const FlightHeader(),

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
                            style: const TextStyle(
                              color: AppColors.white,
                            ),
                          ),
                        );
                      }

                      if (state is FlightLoaded) {
                        if (state.flights.isEmpty) {
                          return const Center(
                            child: Text(
                              "No flights yet",
                              style: TextStyle(
                                color: AppColors.white,
                              ),
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
                            return FlightCard(
                              flight: state.flights[index],
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: BottomNavGlass(
                    currentIndex: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}