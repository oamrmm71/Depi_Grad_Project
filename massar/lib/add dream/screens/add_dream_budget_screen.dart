import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom%20widgets/glass_button.dart';
import 'package:massar/routes.dart';
import 'package:massar/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cubits/add_dream_cubit.dart';
import '../models/add_dream_state.dart';
import '../widgets/dream_stepper_card.dart';

class AddDreamBudgetScreen extends StatelessWidget {
  const AddDreamBudgetScreen({super.key});

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
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
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
                        GestureDetector(
                          onTap: () {
                            context.read<AddDreamCubit>().previousStep();
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
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 120),
                      child: Column(
                        children: [
                          DreamStepperCard(
                            title: 'SET BUDGET',
                            value: '${state.budget} EGP',
                            onIncrement: () {
                              context.read<AddDreamCubit>().incrementBudget(500);
                            },
                            onDecrement: () {
                              context.read<AddDreamCubit>().decrementBudget(500);
                            },
                          ),
                          const SizedBox(height: 26),
                          DreamStepperCard(
                            title: 'NUMBER OF DAYS',
                            value: '${state.days} Days',
                            onIncrement: context.read<AddDreamCubit>().incrementDays,
                            onDecrement: context.read<AddDreamCubit>().decrementDays,
                          ),
                          const SizedBox(height: 26),
                          DreamStepperCard(
                            title: 'NUMBER OF PEOPLE',
                            value: '${state.people}',
                            onIncrement: context.read<AddDreamCubit>().incrementPeople,
                            onDecrement: context.read<AddDreamCubit>().decrementPeople,
                          ),
                          const SizedBox(height: 30),
                          GlassButton(
                            width: double.infinity,
                            height: 54,
                            borderRadius: 26,
                            backgroundColor: AppColors.screenBgGrad3.withOpacity(0.75),
                            onTap: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString(
                                'dream_city_name',
                                state.selectedDestination,
                              );
                              await prefs.setString(
                                'dream_country_name',
                                _resolveCountryName(state.selectedDestination),
                              );
                              await prefs.setInt(
                                'dream_days',
                                state.days > 0 ? state.days : 3,
                              );
                              await prefs.setInt('dream_budget', state.budget);
                              await prefs.setInt('dream_people', state.people);

                              if (!context.mounted) return;
                              context.read<AddDreamCubit>().reset();
                              Navigator.pushReplacementNamed(
                                context,
                                Routes.expenseTracker,
                                arguments: {
                                  'cityName': state.selectedDestination,
                                  'countryName': _resolveCountryName(
                                    state.selectedDestination,
                                  ),
                                  'days': state.days > 0 ? state.days : 3,
                                },
                              );
                            },
                            child: Text(
                              'Confirm',
                              style: GoogleFonts.poppins(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _resolveCountryName(String cityName) {
    switch (cityName.toLowerCase()) {
      case 'dubai':
        return 'United Arab Emirates';
      case 'budapest':
        return 'Hungary';
      case 'cairo':
        return 'Egypt';
      case 'new york':
        return 'United States';
      case 'qatar':
        return 'Qatar';
      case 'london':
        return 'United Kingdom';
      case 'mekka':
        return 'Saudi Arabia';
      case 'rome':
        return 'Italy';
      case 'paris':
        return 'France';
      default:
        return cityName;
    }
  }
}
