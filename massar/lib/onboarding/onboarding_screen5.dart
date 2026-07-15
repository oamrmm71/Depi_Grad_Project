import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/theme/app_colors.dart';
import 'package:massar/routes.dart';
import 'dart:math' as math  ;

class OnboardingScreen5 extends StatelessWidget {
  const OnboardingScreen5({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: Column(
        children:[ SizedBox(
          width: width,
          height: height*0.6,
          child: Stack(
            alignment: AlignmentGeometry.center,
            children: [
              
              Positioned(
                top: height*0.1,
                left: width*0.1,
                child: Transform.rotate(
            angle: -8 * math.pi / 180, // -10°
            child: Image.asset(
              'lib/assets/boarding 2.png',
              width: width * 0.55,
              fit: BoxFit.contain,
            ),
          ),
              ),
             Positioned(
          top: width * 0.4,
          left: width*.24,
             // 5°
            child: Image.asset(
              'lib/assets/boarding 1.png',
              width: width * 0.60,
              fit: BoxFit.contain,
            ),
                ),
             
            ],
          ),
        ),
           
                 Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisSize: MainAxisSize.min,
                 
                      children: [
                        Transform.rotate(angle: -45*math.pi/180,
                        child: Image.asset('lib/assets/ticket.png',width: 40,height: 40,),),
                        SizedBox(width: 5,),
                        SizedBox(
                          width: 230,
                          child: Text('Tailored recommendations that match your style, making every trip uniquely yours.',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w200,
                            height: 1
                            
                          ),
                          
                          ),
                        )
                      ],

                    ),
                SizedBox(height: 32,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisSize: MainAxisSize.min,
                 children: [
                  Image.asset('lib/assets/stopwatch.png',width: 40,height: 40,),
                        SizedBox(width: 5,),
                        SizedBox(
                          width: 230,
                          child: Text('Explore hidden gems and create meaningful travel experiences with ease.',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w200,
                            height: 1
                            
                          ),
                          
                          ),
                        )]
                 
                ),
              SizedBox(height: 40),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              Routes.onboarding6,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navIcon,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "what else?",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      )
            
         
        ]
      ),
    );
  }
}
