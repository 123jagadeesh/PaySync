 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 import 'package:firebase_core/firebase_core.dart';
 import 'package:get/get.dart';
 import 'package:get/get_navigation/src/root/get_material_app.dart';

 import 'package:paysync/firebase_options.dart';
import 'package:paysync/src/features/authentication/controllers/auth_controller.dart';
import 'package:paysync/src/features/authentication/screens/login/login_screen.dart';
import 'package:paysync/src/features/authentication/screens/signup/signup_screen.dart';
 import 'package:paysync/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:paysync/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:paysync/src/features/dashboard/screens/dashboard_screen.dart';
 import 'package:paysync/src/utils/theme/theme.dart';

 void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   try {
     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
     print('Firebase initialized successfully');
     
     // Initialize auth controller with error handling
     final authController = AuthController();
     Get.put(authController);
     
     // Debug print current auth state
     final currentUser = FirebaseAuth.instance.currentUser;
     print('Current user: ${currentUser?.email ?? 'No user logged in'}');
     
   } catch (e) {
     print('Firebase initialization error: $e');
   }
   runApp(const MyApp());
 }
 
 class MyApp extends StatelessWidget {
   const MyApp({super.key});
 
   @override
   Widget build(BuildContext context) {
     return GetMaterialApp(
       title: 'PaySync',  // Updated app title
       debugShowCheckedModeBanner: false,  // Remove debug banner
       theme: TAppTheme.lightTheme,
       darkTheme: TAppTheme.darkTheme,
       themeMode: ThemeMode.system,
       
       initialRoute: '/',
       getPages: [
         GetPage(name: '/', page: () => const SplashScreen()),
         GetPage(
           name: '/welcome', 
           page: () => const WelcomeScreen(),
           transition: Transition.fadeIn
         ),
         GetPage(
           name: '/signup', 
           page: () => const SignUpScreen(),
           transition: Transition.rightToLeft
         ),
         GetPage(
           name: '/login', 
           page: () => const LoginScreen(),
           transition: Transition.rightToLeft
         ),
         GetPage(
           name: '/dashboard', 
           page: () => const DashboardScreen(),
           transition: Transition.fadeIn
         ),
       ],
     );
   }
 }