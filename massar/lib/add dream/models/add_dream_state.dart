class AddDreamState {
  final int step;
  final String selectedDestination;
  final int budget;
  final int days;
  final int people;

  const AddDreamState({
    required this.step,
    required this.selectedDestination,
    required this.budget,
    required this.days,
    required this.people,
  });

  const AddDreamState.initial()
      : step = 0,
        selectedDestination = 'Rome',
        budget = 0,
        days = 0,
        people = 0;

  AddDreamState copyWith({
    int? step,
    String? selectedDestination,
    int? budget,
    int? days,
    int? people,
  }) {
    return AddDreamState(
      step: step ?? this.step,
      selectedDestination: selectedDestination ?? this.selectedDestination,
      budget: budget ?? this.budget,
      days: days ?? this.days,
      people: people ?? this.people,
    );
  }
}
