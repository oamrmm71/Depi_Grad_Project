import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:massar/flights%20screen/models/flight_model.dart';
import '../models/seats.dart';
import '../services/booking_service.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingService bookingService;
  final FlightModel flight;

  BookingCubit(this.bookingService, {required this.flight})
    : super(BookingInitial());

  Future<void> loadSeats() async {
    try {
      emit(BookingLoading());
      final seats = await bookingService.getSeats(flightId: flight.flightId);
      emit(BookingLoaded(seats));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  void toggleSeat(String seatNumber) {
    if (state is! BookingLoaded) return;

    final currentState = state as BookingLoaded;
    final updatedSeats = currentState.seats.map((seat) {
      if (seat.seatNumber != seatNumber || seat.status == SeatStatus.booked) {
        return seat;
      }

      return seat.copyWith(
        status: seat.status == SeatStatus.selected
            ? SeatStatus.available
            : SeatStatus.selected,
      );
    }).toList();

    emit(BookingLoaded(updatedSeats));
  }

  Future<void> confirmBooking() async {
    if (state is! BookingLoaded) return;

    final currentState = state as BookingLoaded;
    final selectedSeats = currentState.seats
        .where((seat) => seat.status == SeatStatus.selected)
        .toList();

    if (selectedSeats.isEmpty) return;

    emit(BookingLoading());

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      await bookingService.confirmBooking(
        flight: flight,
        uid: uid,
        selectedSeats: selectedSeats,
      );
      final seats = await bookingService.getSeats(flightId: flight.flightId);
      emit(BookingLoaded(seats));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
