import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/theme/app_colors.dart';
import 'package:massar/custom%20widgets/bottom_nav_glass.dart';
import 'package:massar/custom%20widgets/glass_button.dart';
import 'package:massar/custom%20widgets/glass_container.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:massar/custom%20widgets/travel_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:massar/home%20screen/cubits/trip_state.dart';
import 'package:massar/home%20screen/models/trip_model.dart';
import 'package:massar/home%20screen/screens/notifications_screen.dart';
import 'package:massar/home%20screen/screens/travel_detail_screen.dart';

import '../cubits/trip_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _searchActive = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TripModel> _filterTrips(List<TripModel> trips) {
    if (_searchQuery.isEmpty) return trips;
    final q = _searchQuery.toLowerCase();
    return trips
        .where(
          (t) =>
              t.cityName.toLowerCase().contains(q) ||
              t.countryName.toLowerCase().contains(q),
        )
        .toList();
  }

  void _closeSearch() {
    setState(() {
      _searchActive = false;
      _searchController.clear();
      _searchQuery = '';
    });
  }

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
                  AppColors.screenBgGrad1,
                  AppColors.screenBgGrad2,
                  AppColors.screenBgGrad3,
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
                  AppColors.glowHigh,
                  AppColors.glowLow,
                  AppColors.transparent,
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
                  backgroundColor: AppColors.avatarBg,
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
                        color: AppColors.white,
                        size: 30,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 2),
                    GlassButton(
                      width: 60,
                      height: 60,
                      borderRadius: 50,
                      child: const Icon(
                        Icons.settings,
                        color: AppColors.white,
                        size: 30,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Title
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
                    color: AppColors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w200,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  'WORLD WITH AI',
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Filter / search bar
          Positioned(
            top: 265,
            left: 20,
            right: _searchActive ? 20 : 0,
            child: SizedBox(
              height: 52,
              child:
                  _searchActive
                      ? _buildSearchRow()
                      : _buildFilterList(context),
            ),
          ),

          // Cards
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
                      child: CircularProgressIndicator(color: AppColors.white),
                    );
                  }

                  if (state is TripError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppColors.white),
                      ),
                    );
                  }

                  if (state is TripLoaded) {
                    final trips = _filterTrips(state.trips);

                    if (trips.isEmpty) {
                      return Center(
                        child: Text(
                          _searchQuery.isEmpty
                              ? 'No trips found'
                              : 'No results for "$_searchQuery"',
                          style: const TextStyle(color: AppColors.white),
                        ),
                      );
                    }

                    return CardSwiper(
                      key: ValueKey(_searchQuery),
                      cardsCount: trips.length,
                      numberOfCardsDisplayed: trips.length >= 3
                          ? 3
                          : trips.length,
                      backCardOffset: const Offset(0, 30),
                      padding: const EdgeInsets.all(0),
                      onSwipe: (previousIndex, currentIndex, direction) {
                        if (!_searchActive &&
                            previousIndex >= state.trips.length - 1) {
                          context.read<TripCubit>().fetchTrips(
                            origin: "CAI",
                            budget: 1000000,
                            loadMore: true,
                          );
                        }
                        return true;
                      },
                      cardBuilder: (
                        context,
                        index,
                        horizontalThresholdPercentage,
                        verticalThresholdPercentage,
                      ) {
                        final trip = trips[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TravelDetailScreen(trip: trip),
                              ),
                            );
                          },
                          child: TravelCard(
                            trip: trip,
                            title: trip.cityName,
                            location: trip.countryName,
                            image: trip.locationImage,
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ),

          // Bottom nav
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

  Widget _buildSearchRow() {
    return Row(
      children: [
        GlassButton(
          width: 52,
          height: 52,
          borderRadius: 50,
          onTap: _closeSearch,
          child: const Icon(Icons.close, color: AppColors.white, size: 22),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GlassContainer(
            height: 52,
            borderRadius: 26,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                cursorColor: AppColors.white,
                decoration: InputDecoration(
                  hintText: 'Search destinations...',
                  hintStyle: GoogleFonts.poppins(
                    color: AppColors.whiteDim,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  isCollapsed: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterList(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        GlassButton(
          width: 52,
          height: 52,
          borderRadius: 50,
          child: const Icon(Icons.search, color: AppColors.white, size: 24),
          onTap: () => setState(() => _searchActive = true),
        ),

        const SizedBox(width: 8),
       

        GlassButton(
          text: 'Tour Package',
          width: 135,
          height: 52,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          borderRadius: 30,
          onTap: () {
            context.read<TripCubit>().fetchTrips(
              origin: "CAI",
              budget: 1000000,
              tripType: 'Tour Package',
            );
          },
        ),

        const SizedBox(width: 8),

        GlassButton(
          text: 'Budget Package',
          width: 150,
          height: 52,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          borderRadius: 30,
          onTap: () {
            context.read<TripCubit>().fetchTrips(
              origin: "CAI",
              budget: 1000000,
              tripType: 'Budget Package',
            );
          },
        ),

        const SizedBox(width: 8),

        GlassButton(
          text: 'Trip Package',
          width: 130,
          height: 52,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          borderRadius: 30,
          onTap: () {
            context.read<TripCubit>().fetchTrips(
              origin: "CAI",
              budget: 1000000,
              tripType: 'Trip Package',
            );
          },
        ),
      ],
    );
  }
}
