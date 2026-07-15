import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/theme/app_colors.dart';
import 'package:massar/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final passportController = TextEditingController();
    final cardNumberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.cardDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * .34,
                width: double.infinity,
                child: Image.asset(
                  "lib/assets/plan.png", 
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Start your Journey",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                      ),
                    ),

                    const SizedBox(height: 26),

                    Row(
                      children: [
                        Expanded(
                          child: _glassField(
                            hint: "First Name",
                            icon: Icons.person,
                            controller: firstNameController,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _glassField(
                            hint: "Last Name",
                            icon: Icons.person,
                            controller: lastNameController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _glassField(
                      hint: "Card Number",
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _glassField(
                            hint: "Card Expiry",
                            controller: expiryController,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _glassField(
                            hint: "CVV",
                            controller: cvvController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                                        _glassField(
                      hint: "Passport No.",
                      icon: Icons.mail,
                      controller: passportController,
                    ),

                    const SizedBox(height: 16),

                    _glassField(
                      hint: "Email",
                      icon: Icons.mail,
                      controller: emailController,
                    ),

                    const SizedBox(height: 16),

                    _glassField(
                      hint: "Password",
                      icon: Icons.lock,
                      obscure: true,
                      controller: passwordController,
                    ),

                    const SizedBox(height: 16),

                    _glassField(
                      hint: "Confirm Password",
                      icon: Icons.lock,
                      obscure: true,
                      highlight: true,
                      controller: confirmPasswordController,
                    ),

                    const SizedBox(height: 26),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: () async {
                              if (passwordController.text != confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Passwords do not match"),
                                  ),
                                );
                                return;
                              }

                              try {
                                await AuthService().signUp(
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  passportNumber: passportController.text,
                                  cardNumber: cardNumberController.text,
                                  cardExpiry: expiryController.text,
                                  cvv: cvvController.text,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Account Created Successfully"),
                                  ),
                                );

                                // Navigate to your home screen
                              } on FirebaseAuthException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.message ?? "Authentication Error"),
                                  ),
                                );
                              }
                            },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.splashBg,
                          foregroundColor: AppColors.navIcon,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: Text(
                          "Take me back",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/login'),
                        child: Text(
                          "its not my first time",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassField({
    required String hint,
    TextEditingController? controller,
    IconData? icon,
    bool obscure = false,
    bool highlight = false,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: highlight
              ? [
                  Colors.white.withOpacity(.22),
                  Colors.white.withOpacity(.08),
                ]
              : [
                  Colors.white.withOpacity(.05),
                  Colors.white.withOpacity(.02),
                ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(.18),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 15,
          ),
          prefixIcon: icon == null
              ? null
              : Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.cardDark,
                      size: 20,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}