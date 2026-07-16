import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:massar/custom%20widgets/glass_container.dart';
import 'package:massar/flights%20screen/models/flight_model.dart';
import 'package:massar/theme/app_colors.dart';

class FlightCard extends StatelessWidget {
  final FlightModel flight;

  const FlightCard({
    super.key,
    required this.flight,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 22,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
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
                crossAxisAlignment:
                    CrossAxisAlignment.end,
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
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                flight.fromCountry,
                style: GoogleFonts.poppins(
                  color: AppColors.whiteDim,
                  fontSize: 12,
                ),
              ),

              Text(
                flight.toCountry,
                style: GoogleFonts.poppins(
                  color: AppColors.whiteDim,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              _Airport(
                airport: flight.fromAirport,
                time: flight.fromTime,
                alignRight: false,
              ),

              const Icon(
                Icons.flight,
                color: AppColors.white,
                size: 26,
              ),

              _Airport(
                airport: flight.toAirport,
                time: flight.toTime,
                alignRight: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Airport extends StatelessWidget {
  final String airport;
  final String time;
  final bool alignRight;

  const _Airport({
    required this.airport,
    required this.time,
    required this.alignRight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignRight
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        Text(
          airport,
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),

        Text(
          time,
          style: GoogleFonts.poppins(
            color: AppColors.whiteDim,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}