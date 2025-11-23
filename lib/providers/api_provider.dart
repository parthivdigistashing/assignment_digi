import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

/// State Management using ChangeNotifier
/// Task 3: Use Provider/ChangeNotifier for managing API data, loading states, and UI refresh
/// Demonstrates: notifyListeners() for UI refresh, state management, error handling
class ApiProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State Variables
  List<dynamic> _users = [];
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _lastResponse;
  int _counterValue = 0; // For Stream demo

  // Getters
  List<dynamic> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get lastResponse => _lastResponse;
  int get counterValue => _counterValue;

  /// Fetch users from API
  /// Demonstrates: async/await, loading states, error handling, notifyListeners
  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Refresh UI - show loading state

    try {
      _users = await _apiService.getUsers();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _users = [];
    } finally {
      _isLoading = false;
      notifyListeners(); // Refresh UI - show data or error
    }
  }

  /// Create a new user via POST
  /// Demonstrates: POST request, response handling, state update
  Future<bool> createUser(String name, String job) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lastResponse = await _apiService.createUser(name: name, job: job);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _lastResponse = null;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update existing user via PUT
  /// Demonstrates: PUT request, update operation, response handling
  Future<bool> updateUser(int userId, String name, String job) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lastResponse = await _apiService.updateUser(
        userId: userId,
        name: name,
        job: job,
      );
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _lastResponse = null;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Stream demo for counter
  /// Task 6: How to use Streams (simple counter stream)
  Stream<int> getCounterStream() async* {
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(seconds: 1));
      yield i;
    }
  }

  /// Increment counter for stream demo
  void incrementCounter() {
    _counterValue++;
    notifyListeners();
  }

  /// Reset counter
  void resetCounter() {
    _counterValue = 0;
    notifyListeners();
  }
}