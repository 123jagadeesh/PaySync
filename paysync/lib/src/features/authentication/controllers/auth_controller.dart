import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:paysync/src/features/apiservice/ApiService.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  final isLoading = false.obs;
  


  @override
  void onReady() {
    super.onReady();
    print('Firebase Auth Instance: ${_auth.app.name}'); // Add this line
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAllNamed('/welcome') : Get.offAllNamed('/dashboard');
  }
 Future<void> signUpWithEmail(String email, String password, String name, String phone,) async {
  try {
    isLoading.value = true;

    // Create the Firebase user
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user!.updateDisplayName(name);

    // Grab the Firebase user
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw Exception('User not found after signup');
    }

    final uid       = firebaseUser.uid;
    final userEmail = firebaseUser.email!;  // renamed so no shadowing

    // Call your backend
    final ok = await ApiService.createUser(
      uid:   uid,
      name:  name,
      email: userEmail,
      phone: phone,     // use the phone argument
    );

    if (!ok) {
      Get.snackbar('Error', 'Signup succeeded but backend save failed',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red);
      return;
    }

    // 4️⃣ Success!
    Get.snackbar('Success', 'Account created!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green);
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed('/dashboard');

  } on FirebaseAuthException catch (e) {
     String message = '';
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'The account already exists for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = e.message ?? 'An unknown error occurred.';
      }
      Get.snackbar(
        'Error', 
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
  } finally {
    isLoading.value = false;
  }
}

  // Future<void> signUpWithEmail(String email, String password, String name) async {
  //   try {
  //     isLoading.value = true;
  //     // Create user and wait for completion
  //     final userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: email, 
  //       password: password
  //     );
      
  //     // Ensure user is created
  //     if (userCredential.user != null) {
  //       // Update display name
  //       await userCredential.user!.updateDisplayName(name);
        
  //       // Verify user is in Firebase
  //       final currentUser = _auth.currentUser;
  //       if (currentUser != null) {
  //         Get.snackbar(
  //           'Success', 
  //           'Account created successfully!',
  //           snackPosition: SnackPosition.TOP,
  //           // ignore: deprecated_member_use
  //           backgroundColor: Colors.green.withOpacity(0.1),
  //           colorText: Colors.green,
  //           duration: const Duration(seconds: 2),
  //         );
          
  //         await Future.delayed(const Duration(seconds: 2));
  //         Get.offAllNamed('/dashboard');
  //       } else {
  //         throw FirebaseAuthException(
  //           code: 'user-not-created',
  //           message: 'Failed to create user account',
  //         );
  //       }
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     String message = '';
  //     switch (e.code) {
  //       case 'weak-password':
  //         message = 'The password provided is too weak.';
  //         break;
  //       case 'email-already-in-use':
  //         message = 'The account already exists for that email.';
  //         break;
  //       case 'invalid-email':
  //         message = 'The email address is not valid.';
  //         break;
  //       default:
  //         message = e.message ?? 'An unknown error occurred.';
  //     }
  //     Get.snackbar(
  //       'Error', 
  //       message,
  //       snackPosition: SnackPosition.TOP,
  //       backgroundColor: Colors.red.withOpacity(0.1),
  //       colorText: Colors.red,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
     if (userCredential.user != null) {
      final user = FirebaseAuth.instance.currentUser;
      final idToken = await user?.getIdToken();
      
      // Fetch secure data from backend using the token
      // if (idToken != null) {
      //   try {
      //     final secureData = await ApiService.fetchSecureData(idToken);
      //     print("Response from secure endpoint: $secureData");
      //   } catch (e) {
      //     print("Error fetching secure data: $e");
      //   }
      // } else {
      //   print("Token is null");
      // }

 
   Get.snackbar(
          'Success', 
          'Login successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 2),
        );
      } else {
        throw FirebaseAuthException(
          code: 'login-failed',
          message: 'Login failed. Please try again.',
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = e.message ?? 'An unknown error occurred.';
      }
      Get.snackbar(
        'Error', 
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/welcome');
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error', 
        e.message ?? 'An error occurred while signing out',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }
}

