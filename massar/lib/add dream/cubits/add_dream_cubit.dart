import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/add_dream_state.dart';

class AddDreamCubit extends Cubit<AddDreamState> {
  AddDreamCubit() : super(const AddDreamState.initial());

  void nextStep() {
    emit(state.copyWith(step: 1));
  }

  void previousStep() {
    emit(state.copyWith(step: 0));
  }

  void reset() {
    emit(const AddDreamState.initial());
  }

  void selectDestination(String destination) {
    emit(state.copyWith(selectedDestination: destination));
  }

  void incrementBudget([int step = 100]) {
    emit(state.copyWith(budget: state.budget + step));
  }

  void decrementBudget([int step = 100]) {
    final nextValue = state.budget - step;
    emit(state.copyWith(budget: nextValue < 0 ? 0 : nextValue));
  }

  void incrementDays() {
    emit(state.copyWith(days: state.days + 1));
  }

  void decrementDays() {
    emit(state.copyWith(days: state.days > 0 ? state.days - 1 : 0));
  }

  void incrementPeople() {
    emit(state.copyWith(people: state.people + 1));
  }

  void decrementPeople() {
    emit(state.copyWith(people: state.people > 0 ? state.people - 1 : 0));
  }
}
