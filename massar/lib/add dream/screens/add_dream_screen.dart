import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom%20widgets/bottom_nav_glass.dart';
import 'package:massar/routes.dart';
import 'package:massar/theme/app_colors.dart';
import '../cubits/add_dream_cubit.dart';
import '../models/add_dream_state.dart';
import '../widgets/dream_arc_painter.dart';

class AddDreamScreen extends StatelessWidget {
  const AddDreamScreen({super.key});

  static const List<String> _destinations = [
    'Paris',
    'Dubai',
    'Budapest',
    'Cairo',
    'New York',
    'Qatar',
    'London',
    'Mekka',
    'Rome',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SafeArea(
          child: BlocBuilder<AddDreamCubit, AddDreamState>(
            builder: (context, state) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: const DreamArcPainter(),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    left: 24,
                    right: 24,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ADD',
                                style: GoogleFonts.poppins(
                                  color: AppColors.whiteSubtle,
                                  fontSize: 30,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                              Text(
                                'A NEW DREAM',
                                style: GoogleFonts.poppins(
                                  color: AppColors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              Routes.home,
                            );
                          },
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white.withOpacity(0.2),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppColors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    top: 120,
                    bottom: 120,
                    child: _DestinationFlow(
                      destinations: _destinations,
                      selectedDestination: state.selectedDestination,
                      onSelect: (destination) {
                        context.read<AddDreamCubit>().selectDestination(destination);
                      },
                      onNext: () {
                        context.read<AddDreamCubit>().nextStep();
                      },
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: MediaQuery.of(context).size.height * 0.48,
                    child: GestureDetector(
                      onTap: () {
                        context.read<AddDreamCubit>().nextStep();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white.withOpacity(0.1),
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.15),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: AppColors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: const BottomNavGlass(currentIndex: 2),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DestinationFlow extends StatelessWidget {
  final List<String> destinations;
  final String selectedDestination;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;

  const _DestinationFlow({
    required this.destinations,
    required this.selectedDestination,
    required this.onSelect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = destinations.indexOf(selectedDestination);
    final effectiveCenter =
        selectedIndex < 0 ? destinations.length ~/ 2 : selectedIndex;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final contentHeight = math.max(screenHeight * 1.7, destinations.length * 110.0);
        final arcCenter = Offset(-screenWidth * 0.24, contentHeight * 0.40);
        final arcRadius = screenWidth * 0.78;
        const arcStartAngle = -1.40;
        const arcSweepAngle = 3.15;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: contentHeight,
            width: screenWidth,
            child: Stack(
              children: [
                ...List.generate(destinations.length, (index) {
                  final destination = destinations[index];
                  final isSelected = index == effectiveCenter;
                  final progress = destinations.length == 1
                      ? 0.5
                      : index / (destinations.length - 1);
                  final mappedProgress = 0.10 + (progress * 0.80);
                  final angle = arcStartAngle + (arcSweepAngle * mappedProgress);
                  final point = Offset(
                    arcCenter.dx + (arcRadius * math.cos(angle)),
                    arcCenter.dy + (arcRadius * math.sin(angle)),
                  );

                  final textStyle = GoogleFonts.poppins(
                    color: isSelected
                        ? AppColors.white
                        : AppColors.white.withOpacity(0.72),
                    fontSize: isSelected ? 31 : 18,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w300,
                    fontStyle: isSelected ? FontStyle.normal : FontStyle.italic,
                  );

                  final textPainter = TextPainter(
                    text: TextSpan(text: destination, style: textStyle),
                    textDirection: TextDirection.ltr,
                  )..layout();

                  final labelWidth = textPainter.width + (isSelected ? 40 : 24);
                  final labelHeight = math.max(
                    textPainter.height,
                    isSelected ? 40.0 : 26.0,
                  );

                  return Positioned(
                    left: point.dx,
                    top: point.dy - (labelHeight / 2),
                    child: GestureDetector(
                      onTap: () => onSelect(destination),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        opacity: isSelected ? 1 : 0.78,
                        child: SizedBox(
                          width: labelWidth,
                          height: labelHeight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (isSelected) ...[
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                              Text(destination, style: textStyle),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

}
