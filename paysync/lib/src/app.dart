import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysync/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:paysync/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:paysync/src/features/authentication/screens/login/login_screen.dart';
import 'package:paysync/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:paysync/src/features/dashboard/screens/dashboard_screen.dart';
import 'package:paysync/src/features/transaction/screens/add_transaction_screen.dart';
import 'package:paysync/src/features/transaction/screens/all_transactions_screen.dart';
import 'package:paysync/src/features/transaction/screens/transaction_details_screen.dart';
import 'package:paysync/src/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      home: const SplashScreen(),
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/welcome', page: () => const WelcomeScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/signup', page: () => const SignUpScreen()),
        GetPage(
          name: '/dashboard', 
          page: () => const DashboardScreen(),
          transition: Transition.fadeIn,
        ),
                  GetPage(
            name: '/transactions',
            page: () => AllTransactionsScreen(),
          ),
          GetPage(
            name: '/transactions/add',
            page: () => const AddTransactionScreen(),
          ),
                  GetPage(
          name: '/transaction-details/:id',
          page: () => const TransactionDetailsScreen(id: '',),
          transition: Transition.rightToLeft,
        ),
      ],
    );
  }
}