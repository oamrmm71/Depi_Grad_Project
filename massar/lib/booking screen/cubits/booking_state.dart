import '../models/seats.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Seat> seats;

  BookingLoaded(this.seats);
}

class BookingError extends BookingState {
  final String message;

  BookingError(this.message);
}