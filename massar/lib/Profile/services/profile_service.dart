import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  User? get currentUser =>
      FirebaseAuth.instance.currentUser;

  DocumentReference<Map<String, dynamic>>?
      get _userDocRef {
    final uid = currentUser?.uid;

    if (uid == null) return null;

    return _firestore
        .collection('users')
        .doc(uid);
  }


  Future<Map<String, dynamic>> loadProfile() async {
    final docRef = _userDocRef;

    if (docRef == null) {
      return {};
    }

    final snapshot = await docRef.get();

    return snapshot.data() ?? {};
  }


  Future<Uint8List?> getProfileImage(
    Map<String, dynamic> data,
  ) async {
    final photoBase64 =
        data['photoBase64'] as String?;

    if (photoBase64 == null ||
        photoBase64.isEmpty) {
      return null;
    }

    try {
      return base64Decode(photoBase64);
    } catch (_) {
      return null;
    }
  }


  Future<void> saveProfile({
    required String firstName,
    required String lastName,
    required String cardNumber,
    required String cardExpiry,
    required String passportNumber,
    required String email,
    Uint8List? imageBytes,
  }) async {
    final docRef = _userDocRef;

    if (docRef == null) return;


    await docRef.set(
      {
        'firstName': firstName,
        'lastName': lastName,
        'cardNumber': cardNumber,
        'cardExpiry': cardExpiry,
        'passportNumber': passportNumber,
        'email': email,

        'photoBase64': imageBytes != null
            ? base64Encode(imageBytes)
            : null,

        'updatedAt':
            FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge: true,
      ),
    );
  }


  Future<void> changePassword({
    required String password,
    required String confirmPassword,
  }) async {

    if (password != confirmPassword) {
      throw Exception(
        'Passwords do not match',
      );
    }


    await currentUser?.updatePassword(
      password,
    );
  }
}