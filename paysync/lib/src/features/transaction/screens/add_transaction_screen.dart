// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:paysync/src/features/transaction/api/transaction_api_service.dart';
// import 'package:paysync/src/features/transaction/models/transaction_model.dart';


// class AddTransactionScreen extends StatefulWidget {
//   @override
//   _AddTransactionScreenState createState() => _AddTransactionScreenState();
// }

// class _AddTransactionScreenState extends State<AddTransactionScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _amountCtrl = TextEditingController();
//   final _categoryCtrl = TextEditingController();        // comma‑separated
//   final _locationCtrl = TextEditingController();
//   final _notesCtrl = TextEditingController();
//   final _paymentMethodCtrl = TextEditingController();   // comma‑separated
//   DateTime _pickedDate = DateTime.now();

//   bool _isLoading = false;

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     final txn = TransactionModel(
//       amount: double.parse(_amountCtrl.text.trim()),
//       category: _categoryCtrl.text.trim().split(','),
//       dateTime: _pickedDate,
//       location: _locationCtrl.text.trim(),
//       notes: _notesCtrl.text.trim(),
//       paymentMethod: _paymentMethodCtrl.text.trim().split(','),
//     );

//     try {
//       final newId = await TransactionApiService.addTransaction(txn);
//       Get.snackbar('Success', 'Transaction created (ID: $newId)',
//           snackPosition: SnackPosition.BOTTOM);
//       Navigator.of(context).pop(); // or reset form
//     } catch (e) {
//       Get.snackbar('Error', e.toString(),
//           snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent);
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add Transaction')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(children: [
//             TextFormField(
//               controller: _amountCtrl,
//               decoration: InputDecoration(labelText: 'Amount'),
//               keyboardType: TextInputType.number,
//               validator: (v) =>
//                   v == null || v.isEmpty ? 'Enter amount' : null,
//             ),
//             TextFormField(
//               controller: _categoryCtrl,
//               decoration: InputDecoration(labelText: 'Category (comma‑sep)'),
//               validator: (v) =>
//                   v == null || v.isEmpty ? 'Enter categories' : null,
//             ),
//             // ... DatePicker for _pickedDate ...
//             TextFormField(
//               controller: _locationCtrl,
//               decoration: InputDecoration(labelText: 'Location'),
//             ),
//             TextFormField(
//               controller: _notesCtrl,
//               decoration: InputDecoration(labelText: 'Notes'),
//             ),
//             TextFormField(
//               controller: _paymentMethodCtrl,
//               decoration:
//                   InputDecoration(labelText: 'Payment Methods (comma‑sep)'),
//             ),
//             const SizedBox(height: 20),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _submit, child: Text('Create Transaction')),
//           ]),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';

/// Form to create a new transaction.
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _paymentCtrl = TextEditingController();
  DateTime _pickedDate = DateTime.now();
  final _ctrl = Get.find<TransactionController>();

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _pickedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _pickedDate = d);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final txn = TransactionModel(
      amount: double.parse(_amountCtrl.text.trim()),
      category: _categoryCtrl.text.split(','),
      dateTime: _pickedDate,
      location: _locationCtrl.text.trim(),
      notes: _notesCtrl.text.trim(),
      paymentMethod: _paymentCtrl.text.split(','),
    );
    _ctrl.create(txn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _amountCtrl,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _categoryCtrl,
              decoration: const InputDecoration(labelText: 'Category (comma‑sep)'),
            ),
            ListTile(
              title: const Text('Date'),
              subtitle: Text('${_pickedDate.toLocal()}'.split(' ')[0]),
              trailing: IconButton(icon: const Icon(Icons.calendar_today), onPressed: _pickDate),
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
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(onPressed: _submit, child: const Text('Create'));
            }),
          ]),
        ),
      ),
    );
  }
}
