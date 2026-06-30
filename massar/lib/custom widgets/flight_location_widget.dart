import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/theme/app_colors.dart';

class FlightLocationWidget extends StatelessWidget {
  final String city;
  final String code;
  final String? time;

  const FlightLocationWidget({
    super.key,
    required this.city,
    required this.code,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          city,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: AppColors.white,
            height: 0.8,
          ),
        ),
        Text(
          code,
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        if (time != null)
          Text(
            time!,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: AppColors.white,
              height: 0.8,
            ),
          ),
      ],
    );
  }
}
