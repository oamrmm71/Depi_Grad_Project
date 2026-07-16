import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/flight_model.dart';
import 'flight_state.dart';

class FlightCubit extends Cubit<FlightState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot>? _subscription;

  FlightCubit() : super(FlightLoading()) {
    loadFlights();
  }

  Future<void> loadFlights() async {
  await _subscription?.cancel();

  final uid = FirebaseAuth.instance.currentUser?.uid;

  if (uid == null) {
    emit(FlightLoaded([]));
    return;
  }

  _subscription = _firestore
      .collection('users')
      .doc(uid)
      .collection('bookings')
      .orderBy('bookedAt', descending: true)
      .snapshots()
      .listen(
        (snapshot) {
          final flights = snapshot.docs
              .map(
                (doc) => FlightModel.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList();

          emit(FlightLoaded(flights));
        },
        onError: (e) {
          emit(FlightError(e.toString()));
        },
      );
}

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}