import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom%20widgets/bottom_nav_glass.dart';
import 'package:massar/custom%20widgets/glass_button.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:massar/custom%20widgets/travel_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:massar/home%20screen/cubits/trip_state.dart';

import '../cubits/trip_cubit.dart';

final List<Map<String, String>> trips = [
  {
    "title": "BALI",
    "location": "Southeast Asia",
    "image": "lib/assets/profile.png",
  },
  {"title": "PARIS", "location": "France", "image": "lib/assets/profile.png"},
  {"title": "TOKYO", "location": "Japan", "image": "lib/assets/profile.png"},
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF00287C),
                  Color(0xFF01253D),
                  Color(0xFF00133F),
                ],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),

          // Glow
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.9, 0.9),
                radius: 1.15,
                colors: [
                  const Color(0xFFBAD1FF).withOpacity(0.28),
                  const Color(0xFFBAD1FF).withOpacity(0.08),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),

          // Top row
          Positioned(
            top: 70,
            left: 24,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: ClipOval(
                    child: Image.asset(
                      'lib/assets/profile.png',
                      width: 98,
                      height: 98,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Row(
                  children: [
                    GlassButton(
                      width: 60,
                      height: 60,
                      borderRadius: 50,
                      child: const Icon(
                        Icons.notifications_on,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () {},
                    ),
                    SizedBox(width: 2),
                    GlassButton(
                      width: 60,
                      height: 60,
                      borderRadius: 50,
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 150,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore The',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w200,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  'WORLD WITH AI',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 265,
            left: 20,
            right: 0,
            child: SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GlassButton(
                    width: 52,
                    height: 52,
                    borderRadius: 50,
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 24,
                    ),
                    onTap: () {},
                  ),

                  const SizedBox(width: 8),

                  GlassButton(
                    width: 52,
                    height: 52,
                    borderRadius: 50,
                    child: const Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                    onTap: () {},
                  ),

                  const SizedBox(width: 8),

                  GlassButton(
                    text: 'Tour Package',
                    width: 135,
                    height: 52,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    borderRadius: 30,
                    onTap: () {},
                  ),

                  const SizedBox(width: 8),

                  GlassButton(
                    text: 'Budget Package',
                    width: 150,
                    height: 52,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    borderRadius: 30,
                    onTap: () {},
                  ),

                  const SizedBox(width: 8),

                  GlassButton(
                    text: 'Trip Package',
                    width: 130,
                    height: 52,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    borderRadius: 30,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 310,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 490,
              child: BlocBuilder<TripCubit, TripState>(
                builder: (context, state) {
                  if (state is TripLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (state is TripError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  if (state is TripLoaded) {
                    if (state is TripLoaded) {
                      if (state.trips.isEmpty) {
                        return const Center(
                          child: Text(
                            "No trips found",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return CardSwiper(
                        cardsCount: state.trips.length,
                        numberOfCardsDisplayed: state.trips.length >= 3
                            ? 3
                            : state.trips.length,
                        backCardOffset: const Offset(0, 30),
                        padding: const EdgeInsets.all(0),

                        onSwipe: (previousIndex, currentIndex, direction) {
                          if (previousIndex >= state.trips.length - 1) {
                            context.read<TripCubit>().fetchTrips(
                              origin: "CAI",
                              budget: 1000000,
                              loadMore: true,
                            );
                          }
                          return true;
                        },

                        cardBuilder:
                            (
                              context,
                              index,
                              horizontalThresholdPercentage,
                              verticalThresholdPercentage,
                            ) {
                              final trip = state.trips[index];

                              return TravelCard(
                                title: trip.cityName,
                                location: trip.locationName,
                                image: trip.locationImage,
                              );
                            },
                      );
                    }
                  }

                  return const SizedBox();
                },
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: BottomNavGlass(
              selectedIndex: 0,
              onTap: (index) {
                print(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
