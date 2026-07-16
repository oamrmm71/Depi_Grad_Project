import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseFirestore {

  final db = FirebaseFirestore.instance;

  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> saveExpenses(
      String tripId,
      List<dynamic> expenses,
      ) async {

    final batch = db.batch();

    for (var e in expenses) {

      final doc = db
          .collection("users")
          .doc(uid)
          .collection("trips")
          .doc(tripId)
          .collection("expenses")
          .doc();

      batch.set(doc, e);
    }

    await batch.commit();
  }

}