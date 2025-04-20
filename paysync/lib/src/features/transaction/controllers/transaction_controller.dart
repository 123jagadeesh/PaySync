import 'package:get/get.dart';
import 'package:collection/collection.dart';
import '../api/transaction_api_service.dart';
import '../models/transaction_model.dart';

/// Manages state and CRUD for transactions.
class TransactionController extends GetxController {
  var transactions = <TransactionModel>[].obs;
  var isLoading    = false.obs;

  /// Load all transactions
  Future<void> loadTransactions(String uid) async {
    try {
      isLoading.value = true;
      final list = await TransactionApiService.getAllTransactions();
      transactions.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Find one by ID in local cache
  TransactionModel? getById(String id) =>
    transactions.firstWhereOrNull((t) => t.id == id);

  /// Create new
  Future<void> create(TransactionModel txn) async {
    try {
      isLoading.value = true;
      final newId = await TransactionApiService.addTransaction(txn);
      transactions.insert(0, txn.copyWith(id: newId));
      Get.back();
      Get.snackbar('Success', 'Transaction created');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Update existing
  Future<void> updateTransaction(TransactionModel txn) async {
    try {
      isLoading.value = true;
      await TransactionApiService.updateTransaction(txn.id!, txn);
      final idx = transactions.indexWhere((t) => t.id == txn.id);
      if (idx != -1) transactions[idx] = txn;
      transactions.refresh();
      Get.back();
      Get.snackbar('Success', 'Transaction updated');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete one
  Future<void> delete(String id) async {
    try {
      isLoading.value = true;
      await TransactionApiService.deleteTransaction(id);
      transactions.removeWhere((t) => t.id == id);
      Get.back();
      Get.snackbar('Deleted', 'Transaction removed');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
