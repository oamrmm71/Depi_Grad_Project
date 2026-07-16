import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/theme/app_colors.dart';

class GlassButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final double fontSize;
  final double borderRadius;
  final FontWeight fontWeight;
  final Color? backgroundColor;

  const GlassButton({
    super.key,
    this.text,
    this.child,
    this.onTap,
    this.width = 320,
    this.height = 52,
    this.fontSize = 24,
    this.borderRadius = 30,
    this.fontWeight = FontWeight.w500,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15,
            sigmaY: 15,
          ),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.glassFill,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child:
                child ??
                Text(
                  text ?? '',
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
