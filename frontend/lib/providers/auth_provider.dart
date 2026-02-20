import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../core/services/auth_service.dart';
import '../../models/user_model.dart';
import '../../utils/app_logger.dart';

/// Authentication state provider
class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  late AuthService _authService;

  // State variables
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;
  User? _currentUser;
  String? _currentUserId;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get currentUser => _currentUser;
  String? get currentUserId => _currentUserId;

  AuthProvider(this._apiService) {
    _authService = AuthService(_apiService);
  }

  /// Initialize authentication provider
  Future<void> initialize() async {
    try {
      await _authService.initialize();
      _isAuthenticated = await _authService.isAuthenticated();
      _currentUserId = await _authService.getCurrentUserId();
      AppLogger.info('AuthProvider initialized. isAuthenticated: $_isAuthenticated');
      notifyListeners();
    } catch (e) {
      AppLogger.error('Error initializing AuthProvider: $e');
      _error = 'Failed to initialize authentication';
      notifyListeners();
    }
  }

  /// Request OTP for phone number
  Future<void> requestOtp(String phone) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _authService.requestOtp(phone);
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      AppLogger.error('Error requesting OTP: $e');
    }
  }

  /// Login with phone and OTP
  Future<bool> loginWithOtp(String phone, String otp) async {
    try {
      _setLoading(true);
      _clearError();

      final authResponse = await _authService.loginWithOtp(phone, otp);
      
      // Update state
      _isAuthenticated = true;
      _currentUserId = authResponse.userId;
      _currentUser = authResponse.user;
      
      AppLogger.info('User logged in successfully');
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      AppLogger.error('Error logging in: $e');
      return false;
    }
  }

  /// Check authentication status
  Future<void> checkAuthenticationStatus() async {
    try {
      _isAuthenticated = await _authService.isAuthenticated();
      if (_isAuthenticated) {
        _currentUserId = await _authService.getCurrentUserId();
      }
      notifyListeners();
    } catch (e) {
      AppLogger.error('Error checking authentication status: $e');
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      _setLoading(true);
      _clearError();
      
      await _authService.logout();
      
      // Clear state
      _isAuthenticated = false;
      _currentUser = null;
      _currentUserId = null;
      
      AppLogger.info('User logged out successfully');
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      AppLogger.error('Error logging out: $e');
    }
  }

  /// Refresh authentication token
  Future<void> refreshToken() async {
    try {
      await _authService.refreshToken();
      AppLogger.info('Token refreshed successfully');
    } catch (e) {
      AppLogger.error('Error refreshing token: $e');
      _setError('Failed to refresh token');
      // If refresh fails, clear authentication
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  /// Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
  }

  /// Helper method to set error
  void _setError(String error) {
    _error = error;
    _isLoading = false;
  }

  /// Helper method to clear error
  void _clearError() {
    _error = null;
  }

  /// Get auth token
  String? getToken() {
    return _authService.getToken();
  }

  /// Verify if token is valid
  bool isTokenValid() {
    return _authService.isTokenValid();
  }

  /// Get auth service (for other services that need it)
  AuthService get authService => _authService;
}
