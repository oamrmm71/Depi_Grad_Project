import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/booking_cubit.dart';
import '../cubits/booking_state.dart';
import '../models/seats.dart';
import '../services/booking_service.dart';
import '../widgets/seat_widget.dart';
import '../../theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingCubit(BookingService())..loadSeats(),
      child: const BookingScreenView(),
    );
  }
}

class BookingScreenView extends StatefulWidget {
  const BookingScreenView({super.key});

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
              AppColors.onboardingGrad3, // Dark navy at the top
              AppColors.onboardingGrad4,
              AppColors.onboardingGrad3, // Deeper navy/black at the bottom
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
                            color: Color(0xffF8F8F3),
                          ),
                        ),
                        Text(
                          'FLIGHT SEAT',
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffF8F8F3),
                            
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Cairo',
                              style: GoogleFonts.poppins(
                               
                                fontSize: 12,
                                color: Color(0xffF8F8F3),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Image.asset(
                              'assets/images/arrow.png',
                              width: 37,
                              height: 37,
                              color: Colors.white.withOpacity(0.8),
                              fit: BoxFit.contain,
                              
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Qatar',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Color(0xffF8F8F3),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    GestureDetector(
                      onTap: () {
                        // Action for closing
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: EdgeInsets.only(top:20),
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

              // Airplane Seat Grid & Confirm Button Container (Expanded to fit the screen without scrolling)
              Expanded(
                child: Center(
                  // Increased to make the airplane image wider on the screen
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double localHeight = constraints.maxHeight;
                      final double localWidth = constraints.maxWidth;

                      final double buttonBottom = localHeight * 0.035;

                      return Stack(
                        children: [
                          // Airplane Background Image from assets
                          Positioned(
                            child: Image.asset(
                              'assets/images/seat layout.png',
                              fit: BoxFit.fitWidth,
                            ),
                          ),

                          // Seat Grid (Positioned relatively to fit cabin space perfectly)
                          Positioned(
                            top:
                                localHeight *
                                0.33, // Shifted further down to fit the main cabin area
                            left: 0,
                            right: 0,
                            bottom:
                                localHeight *
                                0.1, // Shifted up to clear the lower tapering body
                            child: BlocBuilder<BookingCubit, BookingState>(
                              builder: (context, state) {
                                if (state is BookingLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xff01253D),
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

                          // Confirm Button Section (Positioned above/overlapping the plane layout at the bottom)
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

                                return GestureDetector(
                                  onTap: selectedSeats.isEmpty
                                      ? null
                                      : () {
                                          final seatNumbers = selectedSeats
                                              .map((s) => s.seatNumber)
                                              .join(', ');

                                          // Confirm booking to make selected seats unavailable
                                          context
                                              .read<BookingCubit>()
                                              .confirmBooking();

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              backgroundColor: const Color(
                                                0xFF00ADB5,
                                              ),
                                              content: Text(
                                                'Seats confirmed: $seatNumbers',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                  child: Container(
                                    width: double.infinity,
                                    height: 50, // Slightly more compact
                                    decoration: BoxDecoration(
                                      color: selectedSeats.isEmpty
                                          ? const Color(0xFF061B2B)
                                          : const Color(0xFF01253D),
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: selectedSeats.isEmpty
                                            ? Colors.white.withOpacity(0.05)
                                            : const Color(
                                                0xFF7E94A8,
                                              ).withOpacity(0.3),
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
    // Group seats by row
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
        // Spacing between rows: Row 1-3 then a gap then Row 4-6
        final isAfterGap = rowNum == 4;

        return Column(
          children: [
            if (isAfterGap)
              const SizedBox(height: 8), // Responsive vertical separation
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
    // Ensure seats are sorted alphabetically A-F
    rowSeats.sort((a, b) => a.seatNumber.compareTo(b.seatNumber));

    if (rowSeats.length < 6) return const SizedBox.shrink();

    final leftSeats = rowSeats.sublist(0, 3);
    final rightSeats = rowSeats.sublist(3, 6);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Left Group (A, B, C)
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

        // Aisle
        const SizedBox(width: 10), // Muted aisle width
        // Right Group (D, E, F)
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
