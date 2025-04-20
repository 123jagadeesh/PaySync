// lib/src/features/transaction/models/transaction_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a Firestore Transaction document.
class TransactionModel {
  final String? id;
  final double amount;
  final List<String> category;
  final DateTime dateTime;
  final String location;
  final String notes;
  final List<String> paymentMethod;

  TransactionModel({
    this.id,
    required this.amount,
    required this.category,
    required this.dateTime,
    required this.location,
    required this.notes,
    required this.paymentMethod,
  });

  /// Deserialize from JSON (backend response)
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      category: List<String>.from(json['category'] as List),
      dateTime: DateTime.parse(json['dateTime'] as String),
      location: json['location'] as String,
      notes: json['notes'] as String? ?? '',
      paymentMethod: List<String>.from(json['paymentMethod'] as List),
    );
  }

  /// Serialize to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'amount': amount,
      'category': category,
      'dateTime': dateTime.toIso8601String(),
      'location': location,
      'notes': notes,
      'paymentMethod': paymentMethod,
    };
  }

  /// Copy with to help updates
  TransactionModel copyWith({
    String? id,
    double? amount,
    List<String>? category,
    DateTime? dateTime,
    String? location,
    String? notes,
    List<String>? paymentMethod,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
