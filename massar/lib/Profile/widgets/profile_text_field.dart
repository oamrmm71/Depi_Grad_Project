import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:massar/theme/app_colors.dart';
import 'package:massar/custom%20widgets/glass_container.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final bool editing;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.editing,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: 48,
      borderRadius: 24,
      backgroundColor: AppColors.transparent,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: AppColors.white,
              size: 18,
            ),
            const SizedBox(
              width: 10,
            ),
          ],

          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              inputFormatters: inputFormatters,
              readOnly: !editing,
              cursorColor: AppColors.white,
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isCollapsed: true,
                hintText: hint,
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.whiteDim,
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}