import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/theme/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * .48,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: const Color(0xFF072B46),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: size.height * .30,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(0, 1.15),
                            radius: 1.25,
                            colors: [
                              Colors.white.withOpacity(.45),
                              Colors.white.withOpacity(.12),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Plane Image
                   Positioned(
                      top: -180,
                      left: -20,
                      right: -20,
                      child: Image.asset(
                        "lib/assets/plan2.png",
                        width: double.infinity,
                        //fit: BoxFit.fitWidth,
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: size.height * .18,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.splashBg,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),

                    Text(
                      "Continue your Journey",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navIcon,
                      ),
                    ),

                    const SizedBox(height: 28),

                    _textField(
                      hint: "Email",
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 16),

                    _textField(
                      hint: "Password",
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardDark,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: Text(
                          "Take me back",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "its my first time",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppColors.navIcon,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Forgot my password",
                            style: GoogleFonts.poppins(
                              decoration: TextDecoration.underline,
                              color: const Color(0xff758290),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffF7F7F4),
            Color(0xffD6DDE3),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        obscureText: obscure,
        style: GoogleFonts.poppins(
          color: AppColors.navIcon,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xff617180),
            fontSize: 15,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffC8D0D6),
              ),
              child: Icon(
                icon,
                color: AppColors.navIcon,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}