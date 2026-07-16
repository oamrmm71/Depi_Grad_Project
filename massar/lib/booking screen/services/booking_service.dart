import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:massar/flights%20screen/models/flight_model.dart';
import '../models/seats.dart';

class BookingService {
  final FirebaseFirestore _firestore;

  BookingService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Seat>> getSeats({required String flightId}) async {
    final seatsRef = _firestore
        .collection('flights')
        .doc(flightId)
        .collection('seats');

    final snapshot = await seatsRef.get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) => Seat.fromJson(doc.data())).toList();
    }

    final seats = _generateSeats();
    final WriteBatch batch = _firestore.batch();
    final flightDoc = _firestore.collection('flights').doc(flightId);

    for (final seat in seats) {
      batch.set(
        flightDoc.collection('seats').doc(seat.seatNumber),
        seat.toJson(),
      );
    }

    await batch.commit();
    return seats;
  }

  Future<void> confirmBooking({
    required FlightModel flight,
    required String? uid,
    required List<Seat> selectedSeats,
  }) async {
    if (selectedSeats.isEmpty) return;

    final flightDoc = _firestore.collection('flights').doc(flight.flightId);
    final WriteBatch batch = _firestore.batch();
    final bookedAt = FieldValue.serverTimestamp();

    for (final seat in selectedSeats) {
      final seatDoc = flightDoc.collection('seats').doc(seat.seatNumber);
      batch.set(seatDoc, {
        ...seat.toJson(),
        'status': SeatStatus.booked.name,
        'bookedBy': uid,
        'bookedAt': bookedAt,
        'flightId': flight.flightId,
        'stops': flight.stops
      }, SetOptions(merge: true));
    }

    if (uid != null) {
      final bookingRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('bookings')
          .doc('${flight.flightId}_${DateTime.now().millisecondsSinceEpoch}');

      batch.set(bookingRef, {
        'flightId': flight.flightId,
        'flightType': flight.flightType,
        'flightCompany': flight.flightCompany,
        'flightCode': flight.flightCode,
        'date': flight.date,

        'fromCountry': flight.fromCountry,
        'toCountry': flight.toCountry,

        'fromAirport': flight.fromAirport,
        'toAirport': flight.toAirport,

        'fromTime': flight.fromTime,
        'toTime': flight.toTime,

        'selectedSeats': selectedSeats.map((e) => e.seatNumber).toList(),
        'stops':flight.stops,
        'seatCount': selectedSeats.length,
        'bookedAt': bookedAt,
      });
    }

    await batch.commit();
  }

  List<Seat> _generateSeats() {
    const seatLetters = ['A', 'B', 'C', 'D', 'E', 'F'];
    

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
            status: SeatStatus.available,
          ),
        );
      }
    }

    return seats;
  }
}
