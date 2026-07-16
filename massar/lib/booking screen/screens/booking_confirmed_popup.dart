import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:massar/theme/app_colors.dart';

class BookingConfirmedPopup extends StatelessWidget {
  const BookingConfirmedPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
             Stack(
      alignment: Alignment.center,
      children: [

        // Outer glow
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.unreadDot.withOpacity(.18),
                blurRadius: 40,
                spreadRadius: 15,
              ),
            ],
          ),
        ),

        // Blue circle
        Container(
          width: 54,
          height: 54,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.glowHigh
          ),
          child: const Icon(
            Icons.check,
            color: AppColors.onboardingGrad3,
            size: 34,
          ),
        ),
            const SizedBox(height: 28),

            const Text(
              "TRIP BOOKINGS\nCONFIRMED",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.onboardingGrad3,
                height: 1,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "get ready for your next adventure",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.onboardingGrad3,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
          ]
        )
      ),
    );
  }
}
