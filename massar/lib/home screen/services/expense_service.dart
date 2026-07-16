import 'package:massar/expense_tracker/models/expense_model.dart';

class ExpenseService {
  static List<TripModel> getTrips() {
    return [
      TripModel(
        title: "Trip To Bali",
        duration: "5 Days . 4 Nights",
        expenses: [
          ExpenseModel(
            day: 1,
            attractionName: "Tanah Lot Temple",
            imageUrl:
                "https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=500",
            entryFee: 180,
            transportationFee: 120,
          ),
          ExpenseModel(
            day: 1,
            attractionName: "Seminyak Beach",
            imageUrl:
                "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500",
            entryFee: 0,
            transportationFee: 100,
          ),
          ExpenseModel(
            day: 2,
            attractionName: "Ubud Monkey Forest",
            imageUrl:
                "https://images.unsplash.com/photo-1518509562904-e7ef99cdcc86?w=500",
            entryFee: 150,
            transportationFee: 90,
          ),
          ExpenseModel(
            day: 2,
            attractionName: "Tegallalang Rice Terrace",
            imageUrl:
                "https://images.unsplash.com/photo-1514282401047-d79a71a590e8?w=500",
            entryFee: 80,
            transportationFee: 90,
          ),
          ExpenseModel(
            day: 3,
            attractionName: "Ulun Danu Beratan Temple",
            imageUrl:
                "https://images.unsplash.com/photo-1552733407-5d5c46c3bb3b?w=500",
            entryFee: 120,
            transportationFee: 130,
          ),
          ExpenseModel(
            day: 4,
            attractionName: "Nusa Penida Tour",
            imageUrl:
                "https://images.unsplash.com/photo-1519046904884-53103b34b206?w=500",
            entryFee: 350,
            transportationFee: 250,
          ),
        ],
      ),

      TripModel(
        title: "Trip To Rome",
        duration: "5 Days . 4 Nights",
        expenses: [
          ExpenseModel(
            day: 1,
            attractionName: "Colosseum",
            imageUrl:
                "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=500",
            entryFee: 320,
            transportationFee: 70,
          ),
          ExpenseModel(
            day: 1,
            attractionName: "Roman Forum",
            imageUrl:
                "https://images.unsplash.com/photo-1525874684015-58379d421a52?w=500",
            entryFee: 200,
            transportationFee: 70,
          ),
          ExpenseModel(
            day: 2,
            attractionName: "Trevi Fountain",
            imageUrl:
                "https://images.unsplash.com/photo-1529260830199-42c24126f198?w=500",
            entryFee: 0,
            transportationFee: 60,
          ),
          ExpenseModel(
            day: 2,
            attractionName: "Pantheon",
            imageUrl:
                "https://images.unsplash.com/photo-1555992336-cbfdb83d2d07?w=500",
            entryFee: 100,
            transportationFee: 60,
          ),
          ExpenseModel(
            day: 3,
            attractionName: "Vatican Museums",
            imageUrl:
                "https://images.unsplash.com/photo-1531572753322-ad063cecc140?w=500",
            entryFee: 350,
            transportationFee: 80,
          ),
          ExpenseModel(
            day: 4,
            attractionName: "Spanish Steps",
            imageUrl:
                "https://images.unsplash.com/photo-1516483638261-f4dbaf036963?w=500",
            entryFee: 0,
            transportationFee: 60,
          ),
        ],
      ),

      TripModel(
        title: "Trip To Paris",
        duration: "5 Days . 4 Nights",
        expenses: [
          ExpenseModel(
            day: 1,
            attractionName: "Eiffel Tower",
            imageUrl:
                "https://images.unsplash.com/photo-1549144511-f099e773c147?w=500",
            entryFee: 200,
            transportationFee: 200,
          ),
          ExpenseModel(
            day: 1,
            attractionName: "Arc de Triomphe",
            imageUrl:
                "https://images.unsplash.com/photo-1522093007474-d86e9bf7ba6f?w=500",
            entryFee: 200,
            transportationFee: 200,
          ),
          ExpenseModel(
            day: 2,
            attractionName: "Louvre Museum",
            imageUrl:
                "https://images.unsplash.com/photo-1566139884440-1b8391f15d43?w=500",
            entryFee: 200,
            transportationFee: 200,
          ),
          ExpenseModel(
            day: 2,
            attractionName: "Seine River Cruise",
            imageUrl:
                "https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=500",
            entryFee: 200,
            transportationFee: 200,
          ),
        ],
      ),
    ];
  }
}