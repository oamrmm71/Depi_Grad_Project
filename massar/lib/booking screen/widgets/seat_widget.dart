import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/booking_cubit.dart';
import '../models/seats.dart';

class SeatWidget extends StatelessWidget {
  final Seat seat;

  const SeatWidget({
    super.key,
    required this.seat,
  });

  @override
  Widget build(BuildContext context) {
     Color borderColour = const Color(0xff01253D);
    Color bgColour = const Color(0xFFF8F8F3);
        Color textColour = const Color(0xFF7F7F7F);

    switch (seat.status) {
      case SeatStatus.available:
        borderColour = const Color(0xff01253D);
    bgColour = const Color(0xFFF8F8F3);
     Color textColour = const Color(0xFF7F7F7F);
        break;
      case SeatStatus.selected: 
        bgColour = const Color(0xff01253D);
        textColour = Colors.white;
        break;
      case SeatStatus.booked:
        borderColour = const Color(0xFFCCD2D8);
        bgColour = const Color(0xFFE2E7EC);
        textColour = Colors.white.withOpacity(0.1);
        break;
    }

    final isSelected = seat.status == SeatStatus.selected;
    final isBooked = seat.status == SeatStatus.booked;

    return GestureDetector(
      onTap: isBooked
          ? null
          : () {
              context.read<BookingCubit>().toggleSeat(seat.seatNumber);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColour,
          border: Border.all(color: borderColour, width: 1.2),
          borderRadius: BorderRadius.circular(8),
          
        ),
        // Make the name of each seat always appear on it
        child: Text(
          seat.seatNumber,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: isBooked ? Colors.black26 : textColour,
          ),
        ),
      ),
    );
  }
}