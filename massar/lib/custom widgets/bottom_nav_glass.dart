import 'dart:ui';
import 'package:flutter/material.dart';

class BottomNavGlass extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavGlass({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.home_outlined,
      Icons.flight_takeoff_outlined,
      Icons.add,
      Icons.attach_money_outlined,
      Icons.person_outline,
    ];

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
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(45),
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                icons.length,
                (index) => GestureDetector(
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: index == selectedIndex ? 56 : 44,
                    height: index == selectedIndex ? 56 : 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          index == selectedIndex
                              ? Colors.white.withOpacity(0.12)
                              : Colors.transparent,
                      border:
                          index == selectedIndex
                              ? Border.all(
                                color: Colors.white.withOpacity(0.18),
                                width: 1,
                              )
                              : null,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      icons[index],
                      size: index == 2 ? 40 : 36,
                      color: const Color(0xff01103a),
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