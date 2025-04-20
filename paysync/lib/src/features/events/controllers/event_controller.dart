import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<EventModel> events = <EventModel>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> createEvent({
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    required String userId,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final docRef = _firestore.collection('events').doc();
      final event = EventModel(
        id: docRef.id,
        name: name,
        startDate: startDate,
        endDate: endDate,
        userId: userId,
        transactionIds: [],
        totalAmount: 0,
        description: description,
        imageUrl: imageUrl,
      );

      await docRef.set(event.toMap());
      await loadEvents(userId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create event: $e');
    }
  }

  Future<void> loadEvents(String userId) async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: userId)
          .orderBy('startDate', descending: true)
          .get();

      events.value = snapshot.docs
          .map((doc) => EventModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load events: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTransactionToEvent(String eventId, String transactionId, double amount) async {
    try {
      final docRef = _firestore.collection('events').doc(eventId);
      await docRef.update({
        'transactionIds': FieldValue.arrayUnion([transactionId]),
        'totalAmount': FieldValue.increment(amount),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to add transaction to event: $e');
    }
  }
}