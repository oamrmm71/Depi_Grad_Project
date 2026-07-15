import '../models/seats.dart';

class BookingService {
  Future<List<Seat>> getSeats() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return _generateSeats();
  }

  List<Seat> _generateSeats() {
    const seatLetters = ['A', 'B', 'C', 'D', 'E', 'F'];
    const bookedSeatNumbers = {'2B', '2E', '4A', '4F', '5C'};

    final seats = <Seat>[];

    for (int row = 1; row <= 6; row++) {
      for (int i = 0; i < seatLetters.length; i++) {
        String type;

        if (i == 0 || i == 5) {
          type = 'Window';
        } else if (i == 1 || i == 4) {
          type = 'Middle';
        } else {
          type = 'Aisle';
        }

        final seatNumber = '$row${seatLetters[i]}';

        seats.add(
          Seat(
            seatNumber: seatNumber,
            type: type,
            status: bookedSeatNumbers.contains(seatNumber)
                ? SeatStatus.booked
                : SeatStatus.available,
          ),
        );
      }
    }

    return seats;
  }
}
