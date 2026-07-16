import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/add_dream_cubit.dart';
import '../models/add_dream_state.dart';
import 'add_dream_budget_screen.dart';
import 'add_dream_screen.dart';

class AddDreamFlowScreen extends StatelessWidget {
  const AddDreamFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddDreamCubit(),
      child: BlocBuilder<AddDreamCubit, AddDreamState>(
        builder: (context, state) {
          if (state.step == 0) {
            return const AddDreamScreen();
          }
          return const AddDreamBudgetScreen();
        },
      ),
    );
  }
}
