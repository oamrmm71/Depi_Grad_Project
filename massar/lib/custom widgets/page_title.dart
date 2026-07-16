import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/theme/app_colors.dart';

class PageTitle extends StatelessWidget {
  final String firstLine;
  final String secondLine;

  const PageTitle({
    super.key,
    required this.firstLine,
    required this.secondLine,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          firstLine,
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
          secondLine,
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