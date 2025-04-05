import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysync/src/features/authentication/controllers/auth_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PaySync Dashboard'),
        actions: [
          IconButton(
            onPressed: () => authController.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),

              // Quick Actions Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _buildActionCard(
                      icon: Icons.payment,
                      title: 'Send Money',
                      onTap: () {
                        // TODO: Implement send money
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.account_balance_wallet,
                      title: 'Wallet',
                      onTap: () {
                        // TODO: Implement wallet
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.history,
                      title: 'Transactions',
                      onTap: () {
                        // TODO: Implement transactions
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.person,
                      title: 'Profile',
                      onTap: () {
                        // TODO: Implement profile
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}