library default_connector;  // Added library name

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DefaultConnector {
  static final DefaultConnector _instance = DefaultConnector._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  factory DefaultConnector() {
    return _instance;
  }

  DefaultConnector._internal();

  static DefaultConnector get instance => _instance;

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  // Authentication methods can be added here
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    }
  }
}
