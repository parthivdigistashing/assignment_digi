import 'package:http/http.dart' as http;
import 'dart:convert';

/// API Service to handle all HTTP requests (GET, POST, PUT)
/// Demonstrates async/await and error handling with try/catch
class ApiService {
  static const String jsonPlaceholderBase = 'https://jsonplaceholder.typicode.com';
  static const String reqresBase = 'https://reqres.in/api';

  /// GET API - Fetch user list
  /// Task: Fetch a user list and show it on the UI
  Future<List<dynamic>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$jsonPlaceholderBase/users'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Parse JSON response
        final List<dynamic> users = jsonDecode(response.body);
        return users;
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      // Error handling with try/catch
      throw Exception('Error fetching users: $e');
    }
  }

  /// POST API - Submit data and get response
  /// Task: Submit data through a form and show the response
  /// Demonstrates: async/await, JSON encoding, response handling
  Future<Map<String, dynamic>> createUser({
    required String name,
    required String job,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$reqresBase/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'job': job,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        // POST typically returns 201 Created
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  /// PUT API - Update existing data
  /// Task: Update existing data
  /// Demonstrates: async/await, request body, update operation
  Future<Map<String, dynamic>> updateUser({
    required int userId,
    required String name,
    required String job,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$reqresBase/users/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'job': job,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }
}