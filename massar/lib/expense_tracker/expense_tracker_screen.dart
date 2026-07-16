import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom widgets/bottom_nav_glass.dart';
import 'package:massar/expense_tracker/expense_day_card.dart';
import 'package:massar/expense_tracker/models/expense_model.dart';
import 'package:massar/home screen/services/expense_service.dart';
import 'package:massar/theme/app_colors.dart';

class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  State<ExpenseTrackerScreen> createState() =>
      _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  late final List<TripModel> trips;

  int expandedIndex = 2;

  @override
  void initState() {
    super.initState();
    trips = ExpenseService.getTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  extendBody: true,
  backgroundColor: Colors.transparent,

  bottomNavigationBar: Container(
    color: Colors.transparent,
    child: const BottomNavGlass(currentIndex: 3),
  ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.screenBgGrad1,
              AppColors.screenBgGrad2,
              AppColors.screenBgGrad3,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            children: [
              Text(
                "Expenses",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 28,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                ),
              ),

              Text(
                "TRACKER",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 30),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: trips.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 18),
                itemBuilder: (_, index) {
                  return ExpenseDayCard(
                    trip: trips[index],
                    expanded: expandedIndex == index,
                    onTap: () {
                      setState(() {
                        if (expandedIndex == index) {
                          expandedIndex = -1;
                        } else {
                          expandedIndex = index;
                        }
                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}