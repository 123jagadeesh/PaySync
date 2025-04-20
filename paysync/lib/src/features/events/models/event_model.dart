// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final String userId;
  final List<String> transactionIds;
  final double totalAmount;
  final String? description;
  final String? imageUrl;

  EventModel({
    required this.id,
    required this.name,
    required this.startDate,
    this.endDate,
    required this.userId,
    required this.transactionIds,
    required this.totalAmount,
    this.description,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'userId': userId,
      'transactionIds': transactionIds,
      'totalAmount': totalAmount,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: map['endDate'] != null ? (map['endDate'] as Timestamp).toDate() : null,
      userId: map['userId'] ?? '',
      transactionIds: List<String>.from(map['transactionIds'] ?? []),
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      description: map['description'],
      imageUrl: map['imageUrl'],
    );
  }
}