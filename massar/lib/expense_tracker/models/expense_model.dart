class ExpenseModel {
  final int day;
  final String attractionName;
  final String imageUrl;
  final int entryFee;
  final int transportationFee;

  const ExpenseModel({
    required this.day,
    required this.attractionName,
    required this.imageUrl,
    required this.entryFee,
    required this.transportationFee,
  });

  int get total => entryFee + transportationFee;
}

class TripModel {
  final String title;
  final String duration;
  final List<ExpenseModel> expenses;

  const TripModel({
    required this.title,
    required this.duration,
    required this.expenses,
  });
}