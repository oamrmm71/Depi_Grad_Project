import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passportNumber,
    required String cardNumber,
    required String cardExpiry,
    required String cvv,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await _firestore.collection('users').doc(credential.user!.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email.trim(),
      'passportNumber': passportNumber,
      'cardNumber': cardNumber,
      'cardExpiry': cardExpiry,
      'cvv': cvv,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> logout() => _auth.signOut();
}