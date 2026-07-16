import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/expense_tracker/models/expense_model.dart';
import 'package:massar/theme/app_colors.dart';

class ExpenseDayCard extends StatelessWidget {
  final TripModel trip;
  final bool expanded;
  final VoidCallback onTap;

  const ExpenseDayCard({
    super.key,
    required this.trip,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(.18),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.title,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 19,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trip.duration,
                          style: GoogleFonts.poppins(
                            color: AppColors.whiteSubtle,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    duration:
                        const Duration(milliseconds: 300),
                    turns: expanded ? .25 : 0,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),

              AnimatedCrossFade(
                duration:
                    const Duration(milliseconds: 350),
                crossFadeState: expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox(),
                secondChild: Column(
                  children: [
                    const SizedBox(height: 22),

                    const Divider(
                      color: Colors.white24,
                    ),

                    const SizedBox(height: 18),

                    ...trip.expenses.map(
                      (expense) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: 22),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "${expense.day}",
                                  style:
                                      GoogleFonts.poppins(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withOpacity(.08),
                                  borderRadius:
                                      BorderRadius.circular(
                                          20),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius
                                                .circular(16),
                                        child: Image.network(
                                          expense.imageUrl,
                                          height: 150,
                                          width:
                                              double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              height: 150,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    AppColors.screenBgGrad1
                                                        .withOpacity(.85),
                                                    AppColors.screenBgGrad3
                                                        .withOpacity(.85),
                                                  ],
                                                ),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.white70,
                                                  size: 34,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      const SizedBox(
                                          height: 12),

                                      Text(
                                        expense
                                            .attractionName,
                                        style:
                                            GoogleFonts.poppins(
                                          color:
                                              Colors.white,
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                          fontSize: 18,
                                        ),
                                      ),

                                      const SizedBox(
                                          height: 10),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons
                                                .confirmation_number,
                                            color: Colors
                                                .white70,
                                            size: 18,
                                          ),
                                          const SizedBox(
                                              width: 8),
                                          Text(
                                            "Entry Fee",
                                            style:
                                                GoogleFonts
                                                    .poppins(
                                              color: Colors
                                                  .white70,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "${expense.entryFee} EGP",
                                            style:
                                                GoogleFonts
                                                    .poppins(
                                              color: Colors
                                                  .white,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                          height: 8),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.directions_bus,
                                            color: Colors
                                                .white70,
                                            size: 18,
                                          ),
                                          const SizedBox(
                                              width: 8),
                                          Text(
                                            "Transport",
                                            style:
                                                GoogleFonts
                                                    .poppins(
                                              color: Colors
                                                  .white70,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "${expense.transportationFee} EGP",
                                            style:
                                                GoogleFonts
                                                    .poppins(
                                              color: Colors
                                                  .white,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                          height: 12),

                                      Container(
                                        width:
                                            double.infinity,
                                        padding:
                                            const EdgeInsets
                                                .all(12),
                                        decoration:
                                            BoxDecoration(
                                          color: Colors
                                              .white24,
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      16),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Total",
                                              style: GoogleFonts
                                                  .poppins(
                                                color: Colors
                                                    .white,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "${expense.total} EGP",
                                              style: GoogleFonts
                                                  .poppins(
                                                color: Colors
                                                    .white,
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
