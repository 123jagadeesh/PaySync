import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';
import 'package:paysync/src/features/transaction/screens/edit_trasaction_screen.dart';

/// Shows full details + Edit/Delete.
class TransactionDetailsScreen extends StatelessWidget {
  final String id;
  const TransactionDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TransactionController>();
    final txn  = ctrl.getById(id)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.to(() => EditTransactionScreen(transaction: txn)),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, ctrl, id),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ₹${txn.amount}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Category: ${txn.category.join(', ')}'),
            const SizedBox(height: 8),
            Text('Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(txn.dateTime)}'),
            const SizedBox(height: 8),
            Text('Location: ${txn.location}'),
            const SizedBox(height: 8),
            if (txn.notes.isNotEmpty) Text('Notes: ${txn.notes}'),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, TransactionController ctrl, String id) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Delete Transaction?'),
        content: const Text('Are you sure you want to delete this?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () => ctrl.delete(id),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
