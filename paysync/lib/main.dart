
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:paysync/src/app.dart';
import 'package:paysync/src/features/authentication/controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "YOUR-API-KEY",
      appId: "YOUR-APP-ID",
      messagingSenderId: "YOUR-SENDER-ID",
      projectId: "YOUR-PROJECT-ID",
    ),
  );
  
  // Initialize AuthController
  Get.put(AuthController());
  
  runApp(const App());
}