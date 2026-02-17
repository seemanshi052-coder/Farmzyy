import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/environment.dart';
import '../../core/services/api_service.dart';
import '../../models/user_model.dart';
import '../../utils/app_exceptions.dart';
import '../../utils/app_logger.dart';

/// Authentication service for handling login, logout, and token management
class AuthService {
  final ApiService _apiService;
  late SharedPreferences _prefs;

  AuthService(this._apiService);

  /// Initialize shared preferences
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Request OTP for phone login
  Future<void> requestOtp(String phone) async {
    try {
      AppLogger.info('Requesting OTP for phone: $phone');
      
      // Validate phone
      if (phone.isEmpty || phone.length != 10) {
        throw ValidationException(
          message: 'Phone number must be 10 digits',
        );
      }

      // In a real app, you would call the backend to send OTP
      // For now, we'll simulate it
      // In production: await _apiService.post('/auth/request-otp', data: {'phone': phone});
      
      AppLogger.info('OTP requested successfully');
    } catch (e) {
      AppLogger.error('Error requesting OTP: $e');
      rethrow;
    }
  }

  /// Login with phone and OTP
  Future<AuthResponse> loginWithOtp(String phone, String otp) async {
    try {
      AppLogger.info('Logging in with phone: $phone and OTP');

      // Validate inputs
      if (phone.isEmpty || phone.length != 10) {
        throw ValidationException(
          message: 'Invalid phone number',
        );
      }
      if (otp.isEmpty || otp.length != 6) {
        throw ValidationException(
          message: 'OTP must be 6 digits',
        );
      }

      // Call API
      final response = await _apiService.post(
        Environment.authLoginEndpoint,
        data: {
          'phone': phone,
          'otp': otp,
        },
      );

      // Parse response
      final authData = response['data'] as Map<String, dynamic>;
      final authResponse = AuthResponse.fromJson(authData);

      // Save token
      await _apiService.saveToken(authResponse.accessToken);

      // Save user ID
      await _prefs.setString(Environment.userIdKey, authResponse.userId);

      // Save user data if available
      if (authResponse.user != null) {
        await _saveUserData(authResponse.user!);
      }

      AppLogger.info('Login successful for user: ${authResponse.userId}');
      return authResponse;
    } catch (e) {
      AppLogger.error('Error during login: $e');
      rethrow;
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = _prefs.getString(Environment.tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      AppLogger.error('Error checking authentication: $e');
      return false;
    }
  }

  /// Get current user ID
  Future<String?> getCurrentUserId() async {
    try {
      return _prefs.getString(Environment.userIdKey);
    } catch (e) {
      AppLogger.error('Error getting user ID: $e');
      return null;
    }
  }

  /// Get current user data
  Future<User?> getCurrentUser() async {
    try {
      final userJson = _prefs.getString('user_data');
      if (userJson != null) {
        // In a real app, you would deserialize the JSON
        // For now, just return null if needed to fetch fresh
        return null;
      }
      return null;
    } catch (e) {
      AppLogger.error('Error getting current user: $e');
      return null;
    }
  }

  /// Refresh authentication token
  Future<void> refreshToken() async {
    try {
      AppLogger.info('Refreshing authentication token');
      
      // In a real app, you would call a refresh endpoint
      // For now, this is a placeholder
      // await _apiService.post('/auth/refresh');
      
      AppLogger.info('Token refreshed successfully');
    } catch (e) {
      AppLogger.error('Error refreshing token: $e');
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      AppLogger.info('Logging out user');
      
      // Call logout endpoint if needed
      // await _apiService.post('/auth/logout');
      
      // Clear token
      await _apiService.clearToken();
      
      // Clear user data
      await _prefs.remove(Environment.userIdKey);
      await _prefs.remove('user_data');
      
      AppLogger.info('Logout successful');
    } catch (e) {
      AppLogger.error('Error during logout: $e');
      rethrow;
    }
  }

  /// Save user data locally
  Future<void> _saveUserData(User user) async {
    try {
      // In a real app, you might serialize and save the full user object
      await _prefs.setString(Environment.userIdKey, user.userId);
      AppLogger.info('User data saved');
    } catch (e) {
      AppLogger.error('Error saving user data: $e');
    }
  }

  /// Get auth token
  String? getToken() {
    try {
      return _prefs.getString(Environment.tokenKey);
    } catch (e) {
      AppLogger.error('Error getting token: $e');
      return null;
    }
  }

  /// Verify if token is valid (not checking expiry in this simple version)
  bool isTokenValid() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all authentication data
  Future<void> clearAuth() async {
    try {
      await _apiService.clearToken();
      await _prefs.remove(Environment.userIdKey);
      await _prefs.remove('user_data');
      AppLogger.info('Authentication data cleared');
    } catch (e) {
      AppLogger.error('Error clearing auth data: $e');
    }
  }
}
