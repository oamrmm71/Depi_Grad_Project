import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom%20widgets/glass_container.dart';
import 'package:massar/theme/app_colors.dart';

class DreamStepperCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const DreamStepperCard({
    super.key,
    required this.title,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: double.infinity,
      borderRadius: 28,
      backgroundColor: AppColors.glassFill.withOpacity(0.22),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            GlassContainer(
              borderRadius: 24,
              backgroundColor: AppColors.white.withOpacity(0.18),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    _StepperCircleButton(
                      icon: Icons.add,
                      onTap: onIncrement,
                    ),
                    const Spacer(),
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    _StepperCircleButton(
                      icon: Icons.remove,
                      onTap: onDecrement,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperCircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white.withOpacity(0.18),
          border: Border.all(color: AppColors.white.withOpacity(0.25)),
        ),
        child: Icon(
          icon,
          size: 22,
          color: AppColors.navIcon,
        ),
      ),
    );
  }
}
