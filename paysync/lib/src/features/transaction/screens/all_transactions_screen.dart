import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysync/src/features/authentication/controllers/auth_controller.dart';
import '../controllers/transaction_controller.dart';
import 'transaction_details_screen.dart';

/// Lists all transactions (amount + category).
class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({Key? key}) : super(key: key);

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  final _ctrl = Get.put(TransactionController());
  final _authCtrl = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _ctrl.loadTransactions(_authCtrl.firebaseUser.value!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Transactions')),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_ctrl.transactions.isEmpty) {
          return const Center(child: Text('No transactions found.'));
        }
        return ListView.builder(
          itemCount: _ctrl.transactions.length,
          itemBuilder: (_, i) {
            final txn = _ctrl.transactions[i];
            return ListTile(
              title: Text('₹${txn.amount.toStringAsFixed(2)}'),
              subtitle: Text(txn.category.join(', ')),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.to(
                () => TransactionDetailsScreen(id: txn.id!),
              ),
            );
          },
        );
      }),
    );
  }
}
