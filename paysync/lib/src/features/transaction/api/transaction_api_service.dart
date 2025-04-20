import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';

/// Handles HTTP calls to your Spring Boot backend.
class TransactionApiService {
  static const _baseUrl = 'http://localhost:8080';

  /// CREATE
  static Future<String> addTransaction(TransactionModel txn) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final uri = Uri.parse('$_baseUrl/transactions/add?uid=$uid');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(txn.toJson()),
    );
    if (resp.statusCode == 200) {
      // API returns: "Transaction created with ID: <id>"
      return resp.body.split(': ').last.trim();
    }
    throw Exception('Add failed: ${resp.body}');
  }

  /// READ ALL
  static Future<List<TransactionModel>> getAllTransactions() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final uri = Uri.parse('$_baseUrl/transactions/all?uid=$uid');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return data.map((j) => TransactionModel.fromJson(j)).toList();
    }
    throw Exception('Fetch failed: ${resp.body}');
  }

  /// UPDATE
  static Future<void> updateTransaction(String id, TransactionModel txn) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final uri = Uri.parse(
      '$_baseUrl/transactions/update?uid=$uid&transactionId=$id'
    );
    final resp = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(txn.toJson()),
    );
    if (resp.statusCode != 200) {
      throw Exception('Update failed: ${resp.body}');
    }
  }

  /// DELETE
  static Future<void> deleteTransaction(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final uri = Uri.parse(
      '$_baseUrl/transactions/delete?uid=$uid&transactionId=$id'
    );
    final resp = await http.delete(uri);
    if (resp.statusCode != 200) {
      throw Exception('Delete failed: ${resp.body}');
    }
  }
}
