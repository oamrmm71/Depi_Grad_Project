import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/flights%20screen/models/flight_model.dart';
import '../cubits/booking_cubit.dart';
import '../cubits/booking_state.dart';
import '../models/seats.dart';
import '../services/booking_service.dart';
import '../widgets/seat_widget.dart';
import '../../theme/app_colors.dart';
import 'booking_confirmed_popup.dart';


class BookingScreen extends StatelessWidget {
  final FlightModel flight;

  const BookingScreen({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookingCubit(BookingService(), flight: flight)..loadSeats(),
      child: BookingScreenView(flight: flight),
    );
  }
}

class BookingScreenView extends StatefulWidget {
  final FlightModel flight;

  const BookingScreenView({super.key, required this.flight});

  @override
  State<BookingScreenView> createState() => _BookingScreenViewState();
}

class _BookingScreenViewState extends State<BookingScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.onboardingGrad3,
              AppColors.onboardingGrad4,
              AppColors.onboardingGrad3,
            ],
            transform: GradientRotation(0.8),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CHOOSE',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w200,
                            color: AppColors.splashBg,
                          ),
                        ),
                        Text(
                          'FLIGHT SEAT',
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: AppColors.splashBg,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Cairo',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.splashBg,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Image.asset(
                              'assets/images/arrow.png',
                              width: 37,
                              height: 37,
                              color: AppColors.white.withOpacity(0.8),
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Qatar',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.splashBg,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {  Navigator.pop(context);},
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double localHeight = constraints.maxHeight;
                      final double localWidth = constraints.maxWidth;

                      final double buttonBottom = localHeight * 0.035;

                      return Stack(
                        children: [
                          Positioned(
                            child: Image.asset(
                              'assets/images/seat layout.png',
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Positioned(
                            top: localHeight * 0.33,
                            left: 0,
                            right: 0,
                            bottom: localHeight * 0.1,
                            child: BlocBuilder<BookingCubit, BookingState>(
                              builder: (context, state) {
                                if (state is BookingLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.screenBgGrad2,
                                    ),
                                  );
                                } else if (state is BookingLoaded) {
                                  return _buildSeatMap(state.seats);
                                } else if (state is BookingError) {
                                  return Center(
                                    child: Text(
                                      'Error: ${state.message}',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          Positioned(
                            left: 24,
                            right: 24,
                            bottom: buttonBottom,
                            child: BlocBuilder<BookingCubit, BookingState>(
                              builder: (context, state) {
                                final List<Seat> selectedSeats =
                                    state is BookingLoaded
                                    ? state.seats
                                          .where(
                                            (s) =>
                                                s.status == SeatStatus.selected,
                                          )
                                          .toList()
                                    : [];

                                return ElevatedButton(
                                  onPressed: selectedSeats.isEmpty
                                      ? null
                                      : () {
                                          showDialog(
      context: context,
      barrierColor: Colors.black45,
      builder: (_) => const BookingConfirmedPopup(),
    );
  
                                          
                                        },
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: selectedSeats.isEmpty
                                          ? AppColors.screenBgGrad3
                                          : AppColors.screenBgGrad2,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: selectedSeats.isEmpty
                                            ? Colors.white.withOpacity(0.05)
                                            : AppColors.whiteDim,
                                        width: 1,
                                      ),
                                      boxShadow: selectedSeats.isNotEmpty
                                          ? [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      selectedSeats.isEmpty
                                          ? 'Select Seats'
                                          : 'Confirm (${selectedSeats.length})',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: selectedSeats.isEmpty
                                            ? Colors.white.withOpacity(0.4)
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeatMap(List<Seat> seats) {
    final Map<int, List<Seat>> rowsMap = {};
    for (var seat in seats) {
      final rowStr = seat.seatNumber.replaceAll(RegExp(r'[^0-9]'), '');
      final rowNum = int.tryParse(rowStr) ?? 1;
      if (!rowsMap.containsKey(rowNum)) {
        rowsMap[rowNum] = [];
      }
      rowsMap[rowNum]!.add(seat);
    }

    final sortedRowNumbers = rowsMap.keys.toList()..sort();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: sortedRowNumbers.map((rowNum) {
        final rowSeats = rowsMap[rowNum]!;
        final isAfterGap = rowNum == 4;

        return Column(
          children: [
            if (isAfterGap) const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.2),
              child: _buildRow(context, rowSeats),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildRow(BuildContext context, List<Seat> rowSeats) {
    rowSeats.sort((a, b) => a.seatNumber.compareTo(b.seatNumber));

    if (rowSeats.length < 6) return const SizedBox.shrink();

    final leftSeats = rowSeats.sublist(0, 3);
    final rightSeats = rowSeats.sublist(3, 6);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: leftSeats
              .map(
                (seat) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.4),
                  child: SeatWidget(seat: seat),
                ),
              )
              .toList(),
        ),
        const SizedBox(width: 10),
        Row(
          children: rightSeats
              .map(
                (seat) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.4),
                  child: SeatWidget(seat: seat),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
