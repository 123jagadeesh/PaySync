
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://localhost:8080';

  /// Creates a user document in Firestore via your backend.
  static Future<bool> createUser({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    final url = Uri.parse('$_baseUrl/users/create');
    final body = jsonEncode({
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'password': 'firebase_managed',        // dummy
      'createdAt': DateTime.now().toIso8601String(),
    });

    final response = await http.post(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: body,
    );

    return response.statusCode == 200;
  }
}
