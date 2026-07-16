import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

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
          children: [
            //const SuccessIcon(),
            const SizedBox(height: 28),

            const Text(
              "TRIP BOOKINGS\nCONFIRMED",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xff0E2846),
                height: 1,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "get ready for your next adventure",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
