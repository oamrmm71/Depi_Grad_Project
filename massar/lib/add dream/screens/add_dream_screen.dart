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

class _DestinationFlow extends StatefulWidget {
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
  State<_DestinationFlow> createState() => _DestinationFlowState();
}

class _DestinationFlowState extends State<_DestinationFlow> {
  double _rotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final arcCenter = Offset(-screenWidth * 0.10, screenHeight * 0.46);
        final arcRadius = screenWidth * 0.72;
        const arcStartAngle = -1.36;
        const arcSweepAngle = 2.78;
        final selectedIndex = _selectedIndexForRotation();
        final focusedIndex = selectedIndex < 0 ? widget.destinations.length ~/ 2 : selectedIndex;
        final arrowTop = screenHeight * 0.50 - 26;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragUpdate: (details) {
            setState(() {
              _rotation = _wrap01(_rotation + (details.delta.dy * 0.0028));
            });
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: const DreamArcPainter(),
                ),
              ),
              ...List.generate(widget.destinations.length, (index) {
                final destination = widget.destinations[index];
                final progress = widget.destinations.length == 1
                    ? 0.5
                    : index / (widget.destinations.length - 1);
                final rotatedProgress = _wrap01(progress + _rotation);
                final angle = arcStartAngle +
                    (arcSweepAngle * (0.12 + (rotatedProgress * 0.72)));
                final point = Offset(
                  arcCenter.dx + (arcRadius * math.cos(angle)),
                  arcCenter.dy + (arcRadius * math.sin(angle)),
                );
                final isSelected = index == focusedIndex;

                final textStyle = GoogleFonts.poppins(
                  color: isSelected
                      ? AppColors.white
                      : AppColors.white.withOpacity(0.72),
                  fontSize: isSelected ? 24 : 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w300,
                  fontStyle: isSelected ? FontStyle.normal : FontStyle.italic,
                );

                final textPainter = TextPainter(
                  text: TextSpan(text: destination, style: textStyle),
                  textDirection: TextDirection.ltr,
                )..layout();

                final double labelWidth = textPainter.width + (isSelected ? 30 : 20);
                final double labelHeight = math.max(
                  textPainter.height,
                  isSelected ? 30.0 : 22.0,
                ).toDouble();

                return Positioned(
                  left: point.dx - (labelWidth * 0.12),
                  top: point.dy - (labelHeight / 2),
                  child: GestureDetector(
                    onTap: () {
                      widget.onSelect(destination);
                      _snapToIndex(index);
                    },
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: isSelected ? 1 : 0.76,
                      child: SizedBox(
                        width: labelWidth,
                        height: labelHeight,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(destination, style: textStyle),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              Positioned(
                right: 18,
                top: arrowTop,
                child: GestureDetector(
                  onTap: widget.onNext,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white.withOpacity(0.12),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.18),
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
            ],
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant _DestinationFlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDestination != widget.selectedDestination) {
      final selectedIndex = widget.destinations.indexOf(widget.selectedDestination);
      if (selectedIndex >= 0) {
        _snapToIndex(selectedIndex);
      }
    }
  }

  double _wrap01(double value) {
    final wrapped = value % 1.0;
    return wrapped < 0 ? wrapped + 1.0 : wrapped;
  }

  int _selectedIndexForRotation() {
    if (widget.destinations.isEmpty) {
      return -1;
    }

    const targetProgress = 0.5;
    var bestIndex = 0;
    var bestDistance = double.infinity;

    for (var index = 0; index < widget.destinations.length; index++) {
      final progress = widget.destinations.length == 1
          ? 0.5
          : index / (widget.destinations.length - 1);
      final rotatedProgress = _wrap01(progress + _rotation);
      final distance = _circularDistance(rotatedProgress, targetProgress);
      if (distance < bestDistance) {
        bestDistance = distance;
        bestIndex = index;
      }
    }

    return bestIndex;
  }

  double _circularDistance(double a, double b) {
    final diff = (a - b).abs();
    return math.min(diff, 1.0 - diff);
  }

  void _snapToIndex(int index) {
    final denominator = math.max(widget.destinations.length - 1, 1);
    final progress = index / denominator;
    const targetProgress = 0.5;
    setState(() {
      _rotation = _wrap01(targetProgress - progress);
    });
  }
}
