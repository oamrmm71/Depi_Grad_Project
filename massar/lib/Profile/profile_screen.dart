import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:massar/theme/app_colors.dart';
import 'package:massar/custom%20widgets/bottom_nav_glass.dart';
import 'package:massar/custom%20widgets/glass_container.dart';

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
    final avatarSize = 157;
    final buttonHeight = (size.height * .065).clamp(42.0, 48.0);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.screenBgGrad1,
                  AppColors.screenBgGrad2,
                  AppColors.screenBgGrad3,
                ],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.9, 0.9),
                radius: 1.15,
                colors: [
                  AppColors.glowHigh,
                  AppColors.glowLow,
                  AppColors.transparent,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),


          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                ),

                child: Column(
                  children: [

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          24,
                          18,
                          24,
                          20,
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "MY",
                            style: GoogleFonts.poppins(
                              fontSize: 42,
                              fontWeight: FontWeight.w200,
                              fontStyle: FontStyle.italic,
                              color: AppColors.white,
                              height: 0.9,
                            ),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              "PROFILE",
                            style: GoogleFonts.poppins(
                              fontSize: 44,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                            ),


                            SizedBox(
                              height: size.height * .01,
                            ),


                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: 157 ,
                                    height: 157 ,

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

                                          errorBuilder: (_,__,___){
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
                                      borderRadius:
                                          BorderRadius.circular(30),

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),

                                    child: InkWell(
                                      borderRadius:
                                          BorderRadius.circular(30),

                                      onTap: () {},

                                      child: Center(
                                        child: Text(
                                          "Edit",
                                          style: GoogleFonts.poppins(
                                            color: AppColors.white,
                                            fontSize: 12,
                                            fontWeight:
                                                FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),


                                  SizedBox(
                                    height: size.height * .03,
                                  ),


                                  Row(
                                    children: [

                                      Expanded(
                                        child: _buildField(
                                          controller:
                                              _firstNameController,
                                          hint: "First Name",
                                          icon: Icons.person_outline,
                                          textInputAction:
                                              TextInputAction.next,
                                        ),
                                      ),

                                      const SizedBox(width: 10),


                                      Expanded(
                                        child: _buildField(
                                          controller:
                                              _lastNameController,
                                          hint: "Last Name",
                                          icon: Icons.person_outline,
                                          textInputAction:
                                              TextInputAction.next,
                                        ),
                                      ),

                                    ],
                                  ),


                                  const SizedBox(height: 10),


                                  _buildField(
                                    controller:
                                        _cardNumberController,
                                    hint: "Card Number",
                                    keyboardType:
                                        TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly,

                                      LengthLimitingTextInputFormatter(
                                          16),
                                    ],
                                    textInputAction:
                                        TextInputAction.next,
                                  ),


                                  const SizedBox(height: 10),


                                  Row(
                                    children: [

                                      Expanded(
                                        flex: 6,
                                        child: _buildField(
                                          controller:
                                              _cardExpiryController,
                                          hint: "Card Expiry",
                                          keyboardType:
                                              TextInputType.datetime,
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      Expanded(
                                        flex: 4,
                                        child: _buildField(
                                          controller:
                                              _cvvController,
                                          hint: "CVV",
                                          keyboardType:
                                              TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,

                                            LengthLimitingTextInputFormatter(
                                                4),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                                                    
                                  const SizedBox(height: 10),

                                  _buildField(
                                    controller: _passportController,
                                    hint: "Passport No.",
                                    icon: Icons.badge_outlined,
                                    textInputAction:
                                        TextInputAction.next,
                                  ),


                                  const SizedBox(height: 10),

                                  _buildField(
                                    controller: _emailController,
                                    hint: "Email",
                                    icon: Icons.mail_outline,
                                    keyboardType:
                                        TextInputType.emailAddress,
                                    textInputAction:
                                        TextInputAction.next,
                                  ),


                                  const SizedBox(height: 10),
                                  _buildField(
                                    controller: _passwordController,
                                    hint: "Password",
                                    icon: Icons.lock_outline,
                                    obscureText: true,
                                    textInputAction:
                                        TextInputAction.next,
                                  ),


                                  const SizedBox(height: 10),
                                  _buildField(
                                    controller:
                                        _confirmPasswordController,
                                    hint: "Confirm Password",
                                    icon: Icons.lock_outline,
                                    obscureText: true,
                                    textInputAction:
                                        TextInputAction.done,
                                  ),


                                  SizedBox(
                                    height: size.height * .03,
                                  ),


                                  // SAVE BUTTON
                                  Container(
                                    width: double.infinity,
                                    height: buttonHeight,

                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(30),

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(.25),
                                          blurRadius: 12,
                                          offset:
                                              const Offset(0, 5),
                                        ),
                                      ],
                                    ),

                                    child: ElevatedButton(
                                      onPressed: () {
                                        // TODO: SAVE PROFILE
                                      },

                                      style:
                                          ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color.fromARGB(221, 255, 255, 255),

                                        foregroundColor:
                                            AppColors.reserveBtnText,

                                        elevation: 0,

                                        shadowColor:
                                            Colors.transparent,

                                        shape:
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(
                                                  30),
                                        ),
                                      ),

                                      child: Text(
                                        "Save",

                                        style:
                                            GoogleFonts.poppins(
                                          color:
                                              AppColors.reserveBtnText,

                                          fontSize: 18,

                                          fontWeight:
                                              FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),


                                  SizedBox(
                                    height: size.height * .02,
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),


                    const BottomNavGlass(
                      currentIndex: 4,
                    ),

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

  }) {

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