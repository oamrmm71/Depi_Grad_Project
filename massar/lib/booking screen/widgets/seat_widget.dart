import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:massar/theme/app_colors.dart';
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
     Color borderColour = AppColors.screenBgGrad2;
    Color bgColour = AppColors.splashBg;
        Color textColour = AppColors.whiteDim;

    switch (seat.status) {
      case SeatStatus.available:
        borderColour = AppColors.screenBgGrad2;
    bgColour = AppColors.splashBg;
     textColour = AppColors.whiteDim;
        break;
      case SeatStatus.selected: 
        bgColour = AppColors.screenBgGrad2;
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
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColour,
          border: Border.all(color: borderColour, width: 1.2),
          borderRadius: BorderRadius.circular(9),

        ),

        child: Text(
          seat.seatNumber,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isBooked ? Colors.black26 : textColour,
          ),
        ),
      ),
    );
  }
}