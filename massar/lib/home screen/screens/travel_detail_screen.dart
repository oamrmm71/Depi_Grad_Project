import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/booking%20screen/screens/booking_screen.dart';
import 'package:massar/flights%20screen/models/flight_model.dart';
import 'package:massar/theme/app_colors.dart';
import 'package:massar/custom%20widgets/bottom_nav_glass.dart';
import 'package:massar/custom%20widgets/flight_path_connector.dart';
import 'package:massar/custom%20widgets/glass_button.dart';
import 'package:massar/custom%20widgets/glass_container.dart';
import 'package:massar/custom%20widgets/glow_circle.dart';
import 'package:massar/custom%20widgets/flight_location_widget.dart';
import 'package:massar/custom%20widgets/tour_info_card.dart';

import '../models/trip_model.dart';

class TravelDetailScreen extends StatelessWidget {
  final TripModel trip;

  const TravelDetailScreen({super.key, required this.trip});

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

          // Scrollable content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 74,
                left: 24,
                right: 20,
                bottom: 120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TRIP',
                            style: GoogleFonts.poppins(
                              fontSize: 42,
                              fontWeight: FontWeight.w200,
                              fontStyle: FontStyle.italic,
                              color: AppColors.white,
                              height: 0.9,
                            ),
                          ),
                          Text(
                            'DETAILS',
                            style: GoogleFonts.poppins(
                              fontSize: 44,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GlassButton(
                            width: 140,
                            height: 52,
                            borderRadius: 50,
                            child: Text(
                              'Travel Notes',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                              ),
                            ),
                            onTap: () {},
                          ),
                          GlassButton(
                            width: 52,
                            height: 52,
                            borderRadius: 50,
                            child: const Icon(
                              Icons.close,
                              color: AppColors.white,
                              size: 26,
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  if (trip.departureDate != null || trip.arrivalDate != null)
                    Text(
                      [
                        if (trip.departureDate != null) trip.departureDate!,
                        if (trip.arrivalDate != null) trip.arrivalDate!,
                      ].join(' to '),
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: AppColors.white,
                      ),
                    ),

                  // Plane + content stack
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 190),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: GlassContainer(
                                width: double.infinity,
                                height: 180,
                                borderRadius: 40,
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GlowCircle(
                                              radius: 10,
                                              color: AppColors.flightGlow,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Takeoff Flight',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (trip.flightCode != null)
                                          Text(
                                            trip.flightCode!,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.white,
                                            ),
                                          ),
                                      ],
                                    ),

                                    if (trip.flightCompany != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 30.0,
                                        ),
                                        child: Text(
                                          trip.flightCompany!,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),

                                    const SizedBox(height: 14),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FlightLocationWidget(
                                          city: trip.takeoffCity,
                                          code: trip.takeoffAirport,
                                          time: trip.takeoffTime,
                                        ),

                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            GlowCircle(
                                              radius: 40,
                                              color: AppColors.planeGlow,
                                            ),
                                            Transform.rotate(
                                              angle: 1.57,
                                              child: const Icon(
                                                Icons.airplanemode_active,
                                                color: AppColors.planeIcon,
                                                size: 28,
                                              ),
                                            ),
                                          ],
                                        ),

                                        FlightLocationWidget(
                                          city: trip.destinationCity,
                                          code: trip.destinationAirport,
                                          time: trip.destinationTime,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            if (trip.ticketPrice != null)
                              GlassContainer(
                                width: double.infinity,
                                height: 54,
                                borderRadius: 20,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Economy class',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      Text(
                                        trip.ticketPrice!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            const SizedBox(height: 20),

                            Center(
                              child: FlightPathConnector(
                                circleRadius: 6,
                                lineHeight: 60,
                                lineWidth: 2,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 20),

                            if (trip.tripPlan != null) ...[
                              ...() {
                                final plan = trip.tripPlan!;
                                final cityCountry =
                                    '${trip.destinationCity}, ${trip.countryName}';
                                final hasReturnFlight =
                                    trip.returnFlightCode != null ||
                                    trip.returnFlightCompany != null ||
                                    trip.returnTakeoffTime != null;
                                final widgets = <Widget>[];

                                Widget connector() => Center(
                                  child: FlightPathConnector(
                                    circleRadius: 6,
                                    lineHeight: 40,
                                    lineWidth: 2,
                                    color: AppColors.white,
                                  ),
                                );

                                for (
                                  int i = 0;
                                  i < plan.accommodations.length;
                                  i++
                                ) {
                                  widgets.add(
                                    TourAccommodationCard(
                                      accommodation: plan.accommodations[i],
                                    ),
                                  );
                                  if (i < plan.accommodations.length - 1 ||
                                      plan.attractions.isNotEmpty ||
                                      hasReturnFlight) {
                                    widgets.add(const SizedBox(height: 4));
                                    widgets.add(connector());
                                    widgets.add(const SizedBox(height: 4));
                                  }
                                }

                                for (
                                  int i = 0;
                                  i < plan.attractions.length;
                                  i++
                                ) {
                                  widgets.add(
                                    TourAttractionCard(
                                      attraction: plan.attractions[i],
                                      cityCountry: cityCountry,
                                    ),
                                  );
                                  if (i < plan.attractions.length - 1 ||
                                      hasReturnFlight) {
                                    widgets.add(const SizedBox(height: 4));
                                    widgets.add(connector());
                                    widgets.add(const SizedBox(height: 4));
                                  }
                                }

                                return widgets;
                              }(),
                            ],

                            // Return flight card
                            if (trip.returnFlightCode != null ||
                                trip.returnFlightCompany != null ||
                                trip.returnTakeoffTime != null) ...[
                              if (trip.tripPlan == null) ...[
                                const SizedBox(height: 4),
                                Center(
                                  child: FlightPathConnector(
                                    circleRadius: 6,
                                    lineHeight: 40,
                                    lineWidth: 2,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                              SizedBox(
                                width: double.infinity,
                                child: GlassContainer(
                                  width: double.infinity,
                                  height: 180,
                                  borderRadius: 40,
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              GlowCircle(
                                                radius: 10,
                                                color: AppColors.flightGlow,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Return Flight',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (trip.returnFlightCode != null)
                                            Text(
                                              trip.returnFlightCode!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.white,
                                              ),
                                            ),
                                        ],
                                      ),
                                      if (trip.returnFlightCompany != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 30,
                                          ),
                                          child: Text(
                                            trip.returnFlightCompany!,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 14),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          FlightLocationWidget(
                                            city: trip.destinationCity,
                                            code: trip.destinationAirport,
                                            time: trip.returnTakeoffTime,
                                          ),
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              GlowCircle(
                                                radius: 40,
                                                color: AppColors.planeGlow,
                                              ),
                                              Transform.rotate(
                                                angle: 1.57,
                                                child: const Icon(
                                                  Icons.airplanemode_active,
                                                  color: AppColors.planeIcon,
                                                  size: 28,
                                                ),
                                              ),
                                            ],
                                          ),
                                          FlightLocationWidget(
                                            city: trip.takeoffCity,
                                            code: trip.takeoffAirport,
                                            time: trip.returnDestinationTime,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.reserveBtnBg,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  final flight = FlightModel(
                                    flightId: trip.flightID ?? '',
                                    flightType: 'Transit Flight',
                                    flightCompany: trip.flightCompany ?? 'TBD',
                                    flightCode: trip.flightCode ?? 'TBD',
                                    date: trip.departureDate ?? 'TBD',
                                    fromCountry: trip.takeoffCity,
                                    fromAirport: trip.takeoffAirport,
                                    fromTime: trip.takeoffTime ?? 'TBD',
                                    toCountry: trip.destinationCity,
                                    toAirport: trip.destinationAirport,
                                    toTime: trip.destinationTime ?? 'TBD',
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BookingScreen(flight: flight),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Reserve',
                                  style: TextStyle(
                                    color: AppColors.reserveBtnText,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // Plane in front
                      Transform.translate(
                        offset: const Offset(-24, -40),
                        child: Image.asset(
                          'lib/assets/trip_details_plane.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Fixed bottom nav
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: BottomNavGlass(currentIndex: 0),
          ),
        ],
      ),
    );
  }
}
