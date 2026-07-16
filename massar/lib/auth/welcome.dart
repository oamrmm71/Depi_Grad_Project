import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom widgets/glass_button.dart';
import 'package:massar/custom widgets/glow_circle.dart';
import 'package:massar/routes.dart';
import 'package:massar/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: SafeArea(
        child: Center(
          child: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(color: Color(0xFF072C46)),
            child: Stack(
              children: [
                _buildTopGradient(size),
                _buildGlow(size),
                _buildGlobe(size),
                _buildWelcomeText(size),
                _buildLogo(size),
                _buildBottomGlow(size),
                _buildActionButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopGradient(Size size) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: size.height * 0.36,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF062A44),
              const Color(0xFF082F4C).withOpacity(0.94),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlow(Size size) {
    return Positioned(
      top: size.height * 0.12,
      right: -18,
      child: const GlowCircle(radius: 80, color: Color(0x224D8DFF)),
    );
  }

  Widget _buildGlobe(Size size) {
    return Positioned(
      left: -76,
      right: -76,
      top: size.height * 0.13,
      child: Transform.scale(
        scale: 1.23,
        child: Image.asset(
          'lib/assets/globe.png',
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget _buildWelcomeText(Size size) {
    return Positioned(
      left: size.width * 0.07,
      top: size.height * 0.40,
      child: Text(
        'Welcome to',
        style: GoogleFonts.poppins(
          fontSize: 28,
          color: const Color(0xFF0A3553),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildLogo(Size size) {
    return Positioned(
      left: 0,
      right: 0,
      top: size.height * 0.24,
      child: Center(
        child: Image.asset(
          'lib/assets/logo_bgremove.png',
          width: size.width * 0.85,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildBottomGlow(Size size) {
    return Positioned(
      left: 0,
      right: 0,
      top: size.height * 0.52,
      bottom: 0,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.20),
                Colors.white.withOpacity(0.44),
              ],
              stops: const [0.0, 0.32, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        child: GlassButton(
          width: double.infinity,
          height: 52,
          borderRadius: 30,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          onTap: () {
            Navigator.pushReplacementNamed(context, Routes.home);
          },
          text: 'Begin Journey',
        ),
      ),
    );
  }
}
