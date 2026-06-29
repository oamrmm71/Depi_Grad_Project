class AccommodationModel {
  final String hotelName;
  final String location;
  final String roomType;
  final int nights;
  final int days;
  final int pricePerNightEgp;
  final int totalEgp;

  AccommodationModel({
    required this.hotelName,
    required this.location,
    required this.roomType,
    required this.nights,
    required this.days,
    required this.pricePerNightEgp,
    required this.totalEgp,
  });

  factory AccommodationModel.fromJson(Map<String, dynamic> json) {
    return AccommodationModel(
      hotelName: json['hotel_name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      roomType: json['room_type']?.toString() ?? '',
      nights: (json['nights'] as num?)?.toInt() ?? 1,
      days: (json['days'] as num?)?.toInt() ?? 1,
      pricePerNightEgp: (json['price_per_night_egp'] as num?)?.toInt() ?? 0,
      totalEgp: (json['total_egp'] as num?)?.toInt() ?? 0,
    );
  }
}

class AttractionModel {
  final String name;
  final int? feeEgp;

  AttractionModel({
    required this.name,
    this.feeEgp,
  });

  factory AttractionModel.fromJson(Map<String, dynamic> json) {
    return AttractionModel(
      name: json['name']?.toString() ?? '',
      feeEgp: (json['fee_egp'] as num?)?.toInt(),
    );
  }
}

class TripPlanModel {
  final List<AccommodationModel> accommodations;
  final List<AttractionModel> attractions;

  TripPlanModel({
    required this.accommodations,
    required this.attractions,
  });

  factory TripPlanModel.fromJson(Map<String, dynamic> json) {
    return TripPlanModel(
      accommodations: (json['accommodations'] as List? ?? [])
          .map((e) => AccommodationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      attractions: (json['attractions'] as List? ?? [])
          .map((e) => AttractionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
