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
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 19, 118, 255).withOpacity(.18),
                      blurRadius: 30,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),

              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(70, 0, 55, 165),
                ),
                child: const Icon(
                  Icons.check,
                  color: Color.fromARGB(255, 1, 83, 150),
                  size: 34,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            "TRIP BOOKINGS\nCONFIRMED",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: AppColors.onboardingGrad3,
              height: 0.9,
            ),
          ),

          const SizedBox(height: 30),

          Text(
            "Get ready for your next adventure",
            style: GoogleFonts.poppins(
              fontSize: 14,
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