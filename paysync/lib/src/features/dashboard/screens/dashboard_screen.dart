import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:paysync/src/features/authentication/controllers/auth_controller.dart';
import 'package:paysync/src/features/events/controllers/event_controller.dart';
import 'package:paysync/src/features/transaction/screens/add_transaction_screen.dart';
import 'package:paysync/src/features/transaction/controllers/transaction_controller.dart';
import 'package:paysync/src/features/transaction/screens/all_transactions_screen.dart';
import 'package:paysync/src/features/transaction/screens/transaction_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildHomeScreen(),
      const Center(child: Text('Insights')),
      _buildEventsScreen(), // Update this line
      _buildSettingsScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() =>  AddTransactionScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  final authController = Get.find<AuthController>();
  final transactionController = Get.put(TransactionController());
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // User state handling with ever listener
    ever<User?>(authController.firebaseUser, (user) {
      if (user != null) {
        transactionController.loadTransactions(user.uid);
      }
    });
  }

  // Update the user access in _buildHomeScreen
  Widget _buildHomeScreen() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final currentUser = authController.firebaseUser.value;
                    return Text(
                      'Hello, ${currentUser?.displayName?.split(' ')[0] ?? 'User'}! 👋',
                      style: Theme.of(context).textTheme.titleLarge,
                    );
                  }),
                  const SizedBox(height: 8),
                  Text(
                    '₹12,500 Left',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Obx(() => CircleAvatar(
                radius: 24,
                backgroundImage: authController.firebaseUser.value?.photoURL != null
                    ? NetworkImage(authController.firebaseUser.value!.photoURL!)
                    : null,
                child: authController.firebaseUser.value?.photoURL == null
                    ? const Icon(Icons.person)
                    : null,
              )),
            ],
          ),
          const SizedBox(height: 24),

          // Middle Section - Recent Transactions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                 onPressed: () => Get.to(() => AllTransactionsScreen()),
                child: const Text('See All'),
              ),
            ],
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: transactionController.transactions.length,
                  itemBuilder: (context, index) {
                    final txn = transactionController.transactions[index];
                    final amount = txn.amount;
                    final categories = txn.category.isNotEmpty ? txn.category.join(', ') : 'Uncategorized';
                    final date = txn.dateTime ?? DateTime.now();
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: amount < 0 ? Colors.red.shade100 : Colors.green.shade100,
                          child: Icon(
                            amount < 0 ? Icons.arrow_downward : Icons.arrow_upward,
                            color: amount < 0 ? Colors.red : Colors.green,
                          ),
                        ),
                        title: Text(
                          '₹${amount.abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            color: amount < 0 ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(categories),
                        trailing: Text(
                          DateFormat('dd/MM/yyyy').format(date),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onTap: () => Get.to(() => TransactionDetailsScreen(id: txn.id!)),
                      ),
                    );
                },
                )
                ),
          ),
        ],
      ),
    );
  }

  // Settings screen widget
  Widget _buildSettingsScreen() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              try {
                await authController.logout();
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to logout: $e',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),
          // Add more settings options here
        ],
      ),
    );
  }

  // Add this method
  Widget _buildEventsScreen() {
    final eventController = Get.put(EventController());
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Events',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ElevatedButton.icon(
                onPressed: () => _showCreateEventDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('New Event'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (eventController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (eventController.events.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No events yet',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: eventController.events.length,
                itemBuilder: (context, index) {
                  final event = eventController.events[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(event.name[0].toUpperCase()),
                      ),
                      title: Text(event.name),
                      subtitle: Text(
                        'Total: ₹${event.totalAmount.toStringAsFixed(2)}',
                      ),
                      trailing: Text(
                        DateFormat('dd MMM yyyy').format(event.startDate),
                      ),
                      onTap: () => Get.toNamed('/event-details/${event.id}'),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showCreateEventDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Event Name',
                hintText: 'Enter event name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Enter event description',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Start Date'),
              subtitle: Text(
                DateFormat('dd MMM yyyy').format(selectedDate),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  selectedDate = picked;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final eventController = Get.find<EventController>();
                eventController.createEvent(
                  name: nameController.text,
                  startDate: selectedDate,
                  userId: authController.firebaseUser.value!.uid,
                  description: descriptionController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }



} // Closing brace for _DashboardScreenState class
