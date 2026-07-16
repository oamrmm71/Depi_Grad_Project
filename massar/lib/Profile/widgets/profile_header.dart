import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          "MY",
          style: GoogleFonts.poppins(
            fontSize: 42,
            fontWeight: FontWeight.w200,
            fontStyle: FontStyle.italic,
            color: AppColors.white,
            height: 0.9,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          "PROFILE",
          style: GoogleFonts.poppins(
            fontSize: 44,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}