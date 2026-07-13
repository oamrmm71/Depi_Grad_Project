import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:massar/theme/app_colors.dart';
import 'package:massar/custom widgets/bottom_nav_glass.dart';
import 'package:massar/custom widgets/glass_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _passportController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cvvController.dispose();
    _passportController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final maxWidth = size.width > 700 ? 620.0 : size.width;

    final titleSize = (size.width * .07).clamp(26.0, 30.0);
    final subtitleSize = (size.width * .04).clamp(15.0, 18.0);
    final avatarSize = (size.width * .24).clamp(88.0, 110.0);
    final buttonHeight = (size.height * .065).clamp(42.0, 48.0);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.screenBgGrad1,
                  AppColors.screenBgGrad2,
                  AppColors.screenBgGrad3,
                ],
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.95, 0.95),
                radius: 1.25,
                colors: [
                  AppColors.glowHigh,
                  AppColors.glowLow,
                  Colors.transparent,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "MY",
                              style: GoogleFonts.poppins(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
                                color: AppColors.whiteMuted,
                                fontSize: subtitleSize,
                              ),
                            ),

                            const SizedBox(height: 2),
                            Text(
                              "PROFILE",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                                fontSize: titleSize,
                              ),
                            ),

                            SizedBox(height: size.height * .03),

                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: avatarSize + 8,
                                    height: avatarSize + 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.avatarBg,
                                      border: Border.all(
                                        color: AppColors.glassBorder,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.28),
                                          blurRadius: 16,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: ClipOval(
                                        child: Image.asset(
                                          "lib/assets/profile.png",
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) {
                                            return Container(
                                              color: AppColors.imageFailed,
                                              child: const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 45,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Container(
                                    height: 30,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      color: AppColors.cardDark,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.20),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(30),
                                        onTap: () {},
                                        child: Center(
                                          child: Text(
                                            "Edit",
                                            style: GoogleFonts.poppins(
                                              color: AppColors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: size.height * .03),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildField(
                                          controller: _firstNameController,
                                          hint: "First Name",
                                          icon: Icons.person_outline,
                                          textInputAction: TextInputAction.next,
                                          autofillHints: const [
                                            AutofillHints.givenName,
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: _buildField(
                                          controller: _lastNameController,
                                          hint: "Last Name",
                                          icon: Icons.person_outline,
                                          textInputAction: TextInputAction.next,
                                          autofillHints: const [
                                            AutofillHints.familyName,
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  _buildField(
                                    controller: _cardNumberController,
                                    hint: "Card Number",
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(16),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: _buildField(
                                          controller: _cardExpiryController,
                                          hint: "Card Expiry",
                                          keyboardType: TextInputType.datetime,
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 4,
                                        child: _buildField(
                                          controller: _cvvController,
                                          hint: "CVV",
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  _buildField(
                                    controller: _passportController,
                                    hint: "Passport No.",
                                    icon: Icons.mail_outline,
                                    textInputAction: TextInputAction.next,
                                  ),

                                  const SizedBox(height: 10),

                                  _buildField(
                                    controller: _emailController,
                                    hint: "Email",
                                    icon: Icons.mail_outline,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [AutofillHints.email],
                                  ),

                                  const SizedBox(height: 10),

                                  _buildField(
                                    controller: _passwordController,
                                    hint: "Password",
                                    icon: Icons.lock_outline,
                                    obscureText: true,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [
                                      AutofillHints.newPassword,
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  _buildField(
                                    controller: _confirmPasswordController,
                                    hint: "Confirm Password",
                                    icon: Icons.lock_outline,
                                    obscureText: true,
                                    textInputAction: TextInputAction.done,
                                    autofillHints: const [
                                      AutofillHints.newPassword,
                                    ],
                                  ),

                                  SizedBox(height: size.height * .03),

                                  Container(
                                    width: double.infinity,
                                    height: buttonHeight,
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
                                      onPressed: () {
                                        // TODO: Save profile
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.reserveBtnBg,
                                        foregroundColor: AppColors.reserveBtnText,
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: Text(
                                        "Save",
                                        style: GoogleFonts.poppins(
                                          color: AppColors.reserveBtnText,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: size.height * .02),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const BottomNavGlass(currentIndex: 4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
    Iterable<String>? autofillHints,
  }) {
    return GlassContainer(
      height: 38,
      borderRadius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.notifIconBg,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.notifIconBorder),
              ),
              child: Icon(
                icon,
                size: 14,
                color: AppColors.whiteSubtle,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              inputFormatters: inputFormatters,
              autofillHints: autofillHints,
              cursorColor: AppColors.white,
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
                hintText: hint,
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.whiteDim,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}