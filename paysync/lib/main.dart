
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:paysync/src/features/authentication/screens/login/login_screen.dart';
import 'package:paysync/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:paysync/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:paysync/firebase_options.dart';
import 'package:paysync/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:paysync/src/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override  // Fixed the commented override annotation
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PaySync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/welcome', page: () => const WelcomeScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),  // Removed const
        GetPage(name: '/signup', page: () => SignUpScreen()),  // Removed const
      ],
    );
  }
}