import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:massar/theme/app_colors.dart';

class ProfileSaveButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const ProfileSaveButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final height =
        (MediaQuery.of(context).size.height * .065)
            .clamp(42.0, 48.0);

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(
            221,
            255,
            255,
            255,
          ),
          foregroundColor: AppColors.reserveBtnText,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          loading ? "Saving..." : "Save",
          style: GoogleFonts.poppins(
            color: AppColors.reserveBtnText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}