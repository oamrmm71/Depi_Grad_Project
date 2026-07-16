import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:massar/theme/app_colors.dart';
import 'package:massar/routes.dart';
class BookingConfirmedPopup extends StatelessWidget {
  const BookingConfirmedPopup({super.key});

  @override
  Widget build(BuildContext context) {
     return GestureDetector(
      onTap: () {
        Navigator.pop(context); // close popup

        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.flights,
          (route) => false,
        );
      },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
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

              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.glowHigh,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.onboardingGrad3,
                  size: 34,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          const Text(
            "TRIP BOOKINGS\nCONFIRMED",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.onboardingGrad3,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "Get ready for your next adventure",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.onboardingGrad3,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    )
    );
  
  }
}