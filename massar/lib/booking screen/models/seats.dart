enum SeatStatus {
  available,
  selected,
  booked,
}

class Seat {
  final String seatNumber;
  final String type;
  final SeatStatus status;

  const Seat({
    required this.seatNumber,
    required this.type,
    required this.status,
  });

  Seat copyWith({
    SeatStatus? status,
  }) {
    return Seat(
      seatNumber: seatNumber,
      type: type,
      status: status ?? this.status,
    );
  }

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      seatNumber: json['seatNumber'],
      type: json['type'],
      status: _statusFromString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seatNumber': seatNumber,
      'type': type,
      'status': status.name,
    };
  }

  static SeatStatus _statusFromString(String status) {
    switch (status) {
      case 'booked':
        return SeatStatus.booked;

      case 'selected':
        return SeatStatus.selected;

      default:
        return SeatStatus.available;
    }
  }
}