import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom%20widgets/bottom_nav_glass.dart';
import 'package:massar/expense_tracker/expense_day_card.dart';
import 'package:massar/expense_tracker/models/expense_model.dart';
import 'package:massar/home%20screen/services/expense_service.dart';
import 'package:massar/home%20screen/services/groq_service.dart';
import 'package:massar/home%20screen/services/image_service.dart';
import 'package:massar/theme/app_colors.dart';

class ExpenseTrackerScreen extends StatefulWidget {
  final String? cityName;
  final String? countryName;
  final int days;

  const ExpenseTrackerScreen({
    super.key,
    this.cityName,
    this.countryName,
    this.days = 3,
  });

  @override
  State<ExpenseTrackerScreen> createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  late final Future<List<TripModel>> _tripsFuture;
  int expandedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tripsFuture = _loadTrips();
  }

  Future<List<TripModel>> _loadTrips() async {
    final cityName = widget.cityName?.trim();
    if (cityName == null || cityName.isEmpty) {
      return ExpenseService.getTrips();
    }

    final countryNameValue = widget.countryName?.trim();
    final countryName =
        countryNameValue != null && countryNameValue.isNotEmpty
            ? countryNameValue
            : cityName;
    final days = widget.days > 0 ? widget.days : 3;

    try {
      final groqService = GroqService();
      final imageService = ImageService();
      final plan = await groqService.generateExpensePlan(
        cityName: cityName,
        countryName: countryName,
        days: days,
      );

      final expenses = <ExpenseModel>[];
      for (final item in plan) {
        if (item is! Map) continue;
        final day = _readInt(item['day'], fallback: 1);
        final place = item['place']?.toString().trim();
        if (place == null || place.isEmpty) continue;

        final entryFee = _readInt(
          item['entryFee'] ?? item['fee'] ?? item['price'],
          fallback: 0,
        );
        final transport = _readInt(
          item['transport'] ?? item['transportationFee'] ?? item['transportFee'],
          fallback: 0,
        );
        final imageUrl = await imageService.getPlaceImage(
          cityName: place,
          countryName: countryName,
        );

        expenses.add(
          ExpenseModel(
            day: day,
            attractionName: place,
            imageUrl: imageUrl,
            entryFee: entryFee,
            transportationFee: transport,
          ),
        );
      }

      if (expenses.isEmpty) {
        return _fallbackCityTrip(
          cityName: cityName,
          countryName: countryName,
          days: days,
        );
      }

      expenses.sort((left, right) => left.day.compareTo(right.day));
      return [
        TripModel(
          title: 'Trip To $cityName',
          duration: '$days Days . ${days > 1 ? days - 1 : 0} Nights',
          expenses: expenses,
        ),
      ];
    } catch (_) {
      return _fallbackCityTrip(
        cityName: cityName,
        countryName: countryName,
        days: days,
      );
    }
  }

  Future<List<TripModel>> _fallbackCityTrip({
    required String cityName,
    required String countryName,
    required int days,
  }) async {
    final imageService = ImageService();
    final fallbackAttractions = _fallbackAttractionsForCity(cityName);
    final expenses = <ExpenseModel>[];

    for (var index = 0; index < fallbackAttractions.length; index++) {
      final attraction = fallbackAttractions[index];
      final attractionName = attraction['name']!.toString();
      final imageUrl = await imageService.getPlaceImage(
        cityName: attractionName,
        countryName: countryName,
      );

      expenses.add(
        ExpenseModel(
          day: (index / 2).floor() + 1,
          attractionName: attractionName,
          imageUrl: imageUrl,
          entryFee: attraction['entryFee']!,
          transportationFee: attraction['transportationFee']!,
        ),
      );
    }

    return [
      TripModel(
        title: 'Trip To $cityName',
        duration: '$days Days . ${days > 1 ? days - 1 : 0} Nights',
        expenses: expenses,
      ),
    ];
  }

  List<Map<String, dynamic>> _fallbackAttractionsForCity(String cityName) {
    switch (cityName.toLowerCase()) {
      case 'cairo':
        return [
          {
            'name': 'Pyramids of Giza',
            'image': 'https://images.unsplash.com/photo-1572252009286-268acec5ca0a?w=500',
            'entryFee': 300,
            'transportationFee': 180,
          },
          {
            'name': 'Egyptian Museum',
            'image': 'https://images.unsplash.com/photo-1567973263183-3d6b6b6d2a0b?w=500',
            'entryFee': 200,
            'transportationFee': 120,
          },
          {
            'name': 'Khan El Khalili',
            'image': 'https://images.unsplash.com/photo-1548013146-72479768bada?w=500',
            'entryFee': 0,
            'transportationFee': 100,
          },
          {
            'name': 'Citadel of Saladin',
            'image': 'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c3?w=500',
            'entryFee': 150,
            'transportationFee': 120,
          },
        ];
      case 'new york':
        return [
          {
            'name': 'Statue of Liberty',
            'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500',
            'entryFee': 350,
            'transportationFee': 220,
          },
          {
            'name': 'Central Park',
            'image': 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=500',
            'entryFee': 0,
            'transportationFee': 120,
          },
          {
            'name': 'Times Square',
            'image': 'https://images.unsplash.com/photo-1500916434205-7715d281c8a8?w=500',
            'entryFee': 0,
            'transportationFee': 110,
          },
          {
            'name': 'Empire State Building',
            'image': 'https://images.unsplash.com/photo-1549921296-3a6b6195b26e?w=500',
            'entryFee': 420,
            'transportationFee': 200,
          },
        ];
      case 'dubai':
        return [
          {
            'name': 'Burj Khalifa',
            'image': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=500',
            'entryFee': 400,
            'transportationFee': 200,
          },
          {
            'name': 'Dubai Marina',
            'image': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=500',
            'entryFee': 0,
            'transportationFee': 150,
          },
          {
            'name': 'Dubai Mall',
            'image': 'https://images.unsplash.com/photo-1511818966892-d7d671e672a2?w=500',
            'entryFee': 0,
            'transportationFee': 140,
          },
          {
            'name': 'Palm Jumeirah',
            'image': 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=500',
            'entryFee': 0,
            'transportationFee': 180,
          },
        ];
      case 'qatar':
      case 'doha':
        return [
          {
            'name': 'Museum of Islamic Art',
            'image': 'https://images.unsplash.com/photo-1548013146-72479768bada?w=500',
            'entryFee': 180,
            'transportationFee': 120,
          },
          {
            'name': 'Souq Waqif',
            'image': 'https://images.unsplash.com/photo-1548013146-72479768bada?w=500',
            'entryFee': 0,
            'transportationFee': 100,
          },
          {
            'name': 'The Pearl-Qatar',
            'image': 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=500',
            'entryFee': 0,
            'transportationFee': 130,
          },
          {
            'name': 'Katara Cultural Village',
            'image': 'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?w=500',
            'entryFee': 120,
            'transportationFee': 110,
          },
        ];
      case 'paris':
        return [
          {
            'name': 'Eiffel Tower',
            'image': 'https://images.unsplash.com/photo-1549144511-f099e773c147?w=500',
            'entryFee': 200,
            'transportationFee': 180,
          },
          {
            'name': 'Louvre Museum',
            'image': 'https://images.unsplash.com/photo-1566139884440-1b8391f15d43?w=500',
            'entryFee': 220,
            'transportationFee': 160,
          },
          {
            'name': 'Seine River Cruise',
            'image': 'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=500',
            'entryFee': 150,
            'transportationFee': 140,
          },
          {
            'name': 'Arc de Triomphe',
            'image': 'https://images.unsplash.com/photo-1522093007474-d86e9bf7ba6f?w=500',
            'entryFee': 180,
            'transportationFee': 150,
          },
        ];
      case 'london':
        return [
          {
            'name': 'London Eye',
            'image': 'https://images.unsplash.com/photo-1513639725746-c5d9bbf2f6d7?w=500',
            'entryFee': 350,
            'transportationFee': 180,
          },
          {
            'name': 'British Museum',
            'image': 'https://images.unsplash.com/photo-1523829297378-5d4a7c2c5537?w=500',
            'entryFee': 0,
            'transportationFee': 120,
          },
          {
            'name': 'Tower of London',
            'image': 'https://images.unsplash.com/photo-1513639725746-c5d9bbf2f6d7?w=500',
            'entryFee': 280,
            'transportationFee': 160,
          },
          {
            'name': 'Buckingham Palace',
            'image': 'https://images.unsplash.com/photo-1513639725746-c5d9bbf2f6d7?w=500',
            'entryFee': 180,
            'transportationFee': 150,
          },
        ];
      case 'rome':
        return [
          {
            'name': 'Colosseum',
            'image': 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=500',
            'entryFee': 320,
            'transportationFee': 170,
          },
          {
            'name': 'Trevi Fountain',
            'image': 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=500',
            'entryFee': 0,
            'transportationFee': 100,
          },
          {
            'name': 'Pantheon',
            'image': 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=500',
            'entryFee': 150,
            'transportationFee': 110,
          },
          {
            'name': 'Vatican Museums',
            'image': 'https://images.unsplash.com/photo-1525874684015-58379d421a52?w=500',
            'entryFee': 250,
            'transportationFee': 160,
          },
        ];
      case 'budapest':
        return [
          {
            'name': 'Buda Castle',
            'image': 'https://images.unsplash.com/photo-1555993539-1732c1a0df1e?w=500',
            'entryFee': 220,
            'transportationFee': 140,
          },
          {
            'name': 'Parliament Building',
            'image': 'https://images.unsplash.com/photo-1555993539-1732c1a0df1e?w=500',
            'entryFee': 180,
            'transportationFee': 120,
          },
          {
            'name': 'Széchenyi Thermal Bath',
            'image': 'https://images.unsplash.com/photo-1555993539-1732c1a0df1e?w=500',
            'entryFee': 260,
            'transportationFee': 130,
          },
          {
            'name': 'Fisherman’s Bastion',
            'image': 'https://images.unsplash.com/photo-1555993539-1732c1a0df1e?w=500',
            'entryFee': 100,
            'transportationFee': 120,
          },
        ];
      default:
        return ExpenseService.getTrips().first.expenses
            .map(
              (expense) => <String, dynamic>{
                'name': expense.attractionName,
                'image': expense.imageUrl,
                'entryFee': expense.entryFee,
                'transportationFee': expense.transportationFee,
              },
            )
            .toList();
    }
  }

  int _readInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: const BottomNavGlass(currentIndex: 3),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.screenBgGrad1,
              AppColors.screenBgGrad2,
              AppColors.screenBgGrad3,
            ],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<List<TripModel>>(
            future: _tripsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.white),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Could not load expenses',
                    style: GoogleFonts.poppins(color: AppColors.white),
                  ),
                );
              }

              final trips = snapshot.data ?? ExpenseService.getTrips();

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                children: [
                  Text(
                    widget.cityName == null || widget.cityName!.isEmpty
                        ? 'Expenses'
                        : widget.cityName!,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    'TRACKER',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: trips.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 18),
                    itemBuilder: (_, index) {
                      return ExpenseDayCard(
                        trip: trips[index],
                        expanded: expandedIndex == index,
                        onTap: () {
                          setState(() {
                            if (expandedIndex == index) {
                              expandedIndex = -1;
                            } else {
                              expandedIndex = index;
                            }
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
