import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/auth/login.dart';
import 'package:massar/theme/app_colors.dart';
import 'package:android_intent_plus/android_intent.dart';

class OnboardingScreen7 extends StatelessWidget {
  const OnboardingScreen7({super.key});

  Future<void> _goHome(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (_) => false,
    );
  }

  Future<void> _openAirplaneSettings(BuildContext context) async {
    const intent = AndroidIntent(
      action: 'android.settings.AIRPLANE_MODE_SETTINGS',
    );

    try {
      await intent.launch();
    } catch (_) {}

    if (context.mounted) {
      await _goHome(context);
    }
  }

  Future<void> _showAirplaneDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(.35),
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Colors.white.withOpacity(.15),
            border: Border.all(
              color: Colors.white.withOpacity(.25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.08),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.flight,
                size: 46,
                color: AppColors.navIcon,
              ),

              const SizedBox(height: 14),

              Text(
                "Enable Airplane Mode",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navIcon,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                "For the best travel experience, enable Airplane Mode from your device settings.\n\n"
                "• Save battery\n"
                "• Avoid roaming charges\n"
                "• Stay distraction-free during your trip",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.navIcon.withValues(
                    alpha: .75,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _goHome(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.navIcon.withOpacity(.25),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Not Now",
                          style: GoogleFonts.poppins(
                            color: AppColors.navIcon,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _openAirplaneSettings(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.navIcon,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Allow",
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final titleSize =
        (size.width * .065).clamp(24.0, 34.0);

    final bodySize =
        (size.width * .036).clamp(14.0, 17.0);

    final buttonFont =
        (size.width * .048).clamp(18.0, 22.0);

    final buttonHeight =
        (size.height * .075).clamp(54.0, 60.0);

    final illustrationSize =
        size.width > 1000
            ? 430.0
            : size.width > 700
                ? 380.0
                : 320.0;

    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * .06,
          ),
          child: Column(
            children: [
              SizedBox(
                height: size.height * .06,
              ),
              Text(
                "Airplane Mode",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navIcon,
                ),
              ),
              SizedBox(
                height: size.height * .01,
              ),
              Text(
                "Airplane Mode saves battery, avoids\nroaming, and keeps your trip stress-free.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: bodySize,
                  fontWeight: FontWeight.w300,
                  color: AppColors.navIcon.withValues(
                    alpha: .65,
                  ),
                  height: 1.4,
                ),
              ),
              Expanded(
                child: Center(
                  child: AirplaneIllustration(
                    maxSize: illustrationSize,
                  ),
                ),
              ),
              OnboardingButton(
                height: buttonHeight,
                text: "Allow",
                fontSize: buttonFont,
                backgroundColor: AppColors.navIcon,
                textColor: AppColors.white,
                onPressed: () => _showAirplaneDialog(context),
              ),
              SizedBox(
                height: size.height * .04,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingButton extends StatelessWidget {

  final double height;
  final String text;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;


  const OnboardingButton({
    super.key,
    required this.height,
    required this.text,
    required this.fontSize,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: height,
        
          child: ElevatedButton(
            onPressed: onPressed,
        
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: textColor,
              elevation: 0,
        
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
        
            child: Text(
              text,
        
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: height,
        
          child: ElevatedButton(
            onPressed: onPressed,
        
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.glowHigh,
              elevation: 0,
        
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              shadowColor: const Color.fromARGB(141, 186, 209, 255).withOpacity(0.2),
            ),
        
            child: Text(
              'Skip',
        
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: AppColors.cardDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}



class AirplaneIllustration extends StatefulWidget {

  final double maxSize;

  const AirplaneIllustration({
    super.key,
    required this.maxSize,
  });


  @override
  State<AirplaneIllustration> createState() =>
      _AirplaneIllustrationState();
}



class _AirplaneIllustrationState
    extends State<AirplaneIllustration>
    with SingleTickerProviderStateMixin {


  late final AnimationController _controller;


  static const List<String> icons = [

    "lib/assets/youtube.png",
    "lib/assets/tiktok.png",
    "lib/assets/instgram.png",
    "lib/assets/call.png",
    "lib/assets/snapchat.png",
    "lib/assets/whatsapp.png",
    "lib/assets/facebook.png",
    "lib/assets/facetime.png",

  ];


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }


  @override
  void dispose() {

    _controller.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    final outerCircle = widget.maxSize;

    final innerCircle =
        outerCircle * .54;

    final centerImage =
        outerCircle * .32;

    final radius =
        outerCircle * .40;

    final iconSize =
        outerCircle * .14;



    return SizedBox(

      width: outerCircle,
      height: outerCircle,


      child: Stack(

        alignment: Alignment.center,


        children: [


          Container(

            width: outerCircle,
            height: outerCircle,


            decoration: BoxDecoration(

              shape: BoxShape.circle,

              color: AppColors.white.withValues(
                alpha: .45,
              ),


              boxShadow: [

                BoxShadow(
                  color: AppColors.flightGlow,
                  blurRadius: 18,
                  offset: const Offset(0,8),
                ),

              ],

            ),

          ),



          Container(

            width: innerCircle,
            height: innerCircle,


            decoration: const BoxDecoration(

              color: AppColors.white,

              shape: BoxShape.circle,

            ),



            child: Center(

              child: Image.asset(

                "lib/assets/glass.png",

                width: centerImage,

                fit: BoxFit.contain,

              ),

            ),

          ),




          AnimatedBuilder(

            animation: _controller,


            builder: (_,__) {


              final rotation =
                  _controller.value * 360;



              return Stack(

                alignment: Alignment.center,


                children: [

                  for(int i = 0;
                      i < icons.length;
                      i++)

                    _circleIcon(

                      asset: icons[i],

                      angle:
                          (i * 360 / icons.length)
                          + rotation,

                      radius: radius,

                      iconSize: iconSize,

                    ),

                ],

              );

            },

          ),

        ],

      ),

    );

  }




  Widget _circleIcon({

    required String asset,

    required double angle,

    required double radius,

    required double iconSize,

  }) {


    final radians =
        angle * math.pi / 180;



    return Transform.translate(

      offset: Offset(

        radius * math.cos(radians),

        radius * math.sin(radians),

      ),



      child: SizedBox(

        width: iconSize,

        height: iconSize,


        child: Image.asset(

          asset,

          fit: BoxFit.contain,


          errorBuilder: (_,__,___) {

            return Icon(

              Icons.image_not_supported,

              size: iconSize * .8,

            );

          },

        ),

      ),

    );

  }
}