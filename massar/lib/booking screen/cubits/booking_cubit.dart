import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/seats.dart';
import '../services/booking_service.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingService bookingService;

  BookingCubit(this.bookingService) : super(BookingInitial());

  Future<void> loadSeats() async {
    try {
      emit(BookingLoading());

      final seats = await bookingService.getSeats();

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

  void confirmBooking() {
    if (state is BookingLoaded) {
      final currentSeats = (state as BookingLoaded).seats;
      final updatedSeats = currentSeats.map((seat) {
        if (seat.status == SeatStatus.selected) {
          return seat.copyWith(status: SeatStatus.booked);
        }
        return seat;
      }).toList();
      emit(BookingLoaded(updatedSeats));
    }
  }
}
