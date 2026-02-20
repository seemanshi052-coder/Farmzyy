import 'package:flutter/material.dart';
import '../core/services/api_service.dart';

/// Provider for API Service
class ApiProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  ApiService get apiService => _apiService;

  /// Initialize the API service
  Future<void> initialize() async {
    await _apiService.initializePrefs();
  }

  /// Save authentication token
  Future<void> saveToken(String token) async {
    await _apiService.saveToken(token);
    notifyListeners();
  }

  /// Clear authentication token
  Future<void> clearToken() async {
    await _apiService.clearToken();
    notifyListeners();
  }
}
