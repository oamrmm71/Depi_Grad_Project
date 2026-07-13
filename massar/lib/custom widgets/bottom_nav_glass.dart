import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:massar/routes.dart';
import 'package:massar/theme/app_colors.dart';

const List<String?> _tabRoutes = [
  Routes.home,
  Routes.flights,
  null, // add
  null, // money
  Routes.profile,
];

const _icons = [
  Icons.home_outlined,
  Icons.flight_takeoff_outlined,
  Icons.add,
  Icons.attach_money_outlined,
  Icons.person_outline,
];


class BottomNavGlass extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const BottomNavGlass({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  void _handleTap(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
      return;
    }

    if (index == currentIndex) return;

    final route = _tabRoutes[index];
    if (route == null) return;

    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    final icons = _icons;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(45),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15,
            sigmaY: 15,
          ),
          child: Container(
            height: 82,
            decoration: BoxDecoration(
              color: AppColors.glassFill,
              borderRadius: BorderRadius.circular(45),
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                icons.length,
                (index) => GestureDetector(
                  onTap: () => _handleTap(context, index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: index == currentIndex ? 56 : 44,
                    height: index == currentIndex ? 56 : 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          index == currentIndex
                              ? AppColors.glassFill
                              : AppColors.transparent,
                      border:
                          index == currentIndex
                              ? Border.all(
                                color: AppColors.glassBorder,
                                width: 1,
                              )
                              : null,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      icons[index],
                      size: index == 2 ? 40 : 36,
                      color: AppColors.navIcon,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}