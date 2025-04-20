import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';

/// Form to edit an existing transaction.
class EditTransactionScreen extends StatefulWidget {
  final TransactionModel transaction;
  const EditTransactionScreen({Key? key, required this.transaction}) : super(key: key);

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountCtrl;
  late TextEditingController _categoryCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _notesCtrl;
  late TextEditingController _paymentCtrl;
  final _ctrl = Get.find<TransactionController>();

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    _amountCtrl   = TextEditingController(text: t.amount.toString());
    _categoryCtrl = TextEditingController(text: t.category.join(','));
    _locationCtrl = TextEditingController(text: t.location);
    _notesCtrl    = TextEditingController(text: t.notes);
    _paymentCtrl  = TextEditingController(text: t.paymentMethod.join(','));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _amountCtrl,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _categoryCtrl,
              decoration: const InputDecoration(labelText: 'Categories (comma‑sep)'),
            ),
            TextFormField(
              controller: _locationCtrl,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            TextFormField(
              controller: _paymentCtrl,
              decoration: const InputDecoration(labelText: 'Payment Methods (comma‑sep)'),
            ),
            const SizedBox(height: 20),
            Obx(() {
              return _ctrl.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _save, child: const Text('Update'));
            }),
          ]),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final updated = widget.transaction.copyWith(
      amount: double.parse(_amountCtrl.text.trim()),
      category: _categoryCtrl.text.split(','),
      location: _locationCtrl.text.trim(),
      notes: _notesCtrl.text.trim(),
      paymentMethod: _paymentCtrl.text.split(','),
    );
    _ctrl.updateTransaction(updated);
  }
}
