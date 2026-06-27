import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TravelCard extends StatelessWidget {
  final String title;
  final String location;
  final String image;
  final VoidCallback? onTap;

  const TravelCard({
    super.key,
    required this.title,
    required this.location,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Border
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 2,
              ),
            ),
          ),

          // Text
          Positioned(
            top: 30,
            left: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF002B45),
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  location,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF002B45),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Arrow button
          Positioned(
            top: 25,
            right: 25,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF002B45),
                ),
                child: const Icon(
                  Icons.north_east,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}