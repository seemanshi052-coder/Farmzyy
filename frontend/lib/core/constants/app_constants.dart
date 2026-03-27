
import 'package:flutter/material.dart';

/// App-wide constants
class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFF2E7D32); // Green
  static const Color secondaryColor = Color(0xFF1565C0); // Blue
  static const Color accentColor = Color(0xFFFF6F00); // Orange
  static const Color errorColor = Color(0xFFD32F2F); // Red
  static const Color successColor = Color(0xFF388E3C); // Green
  static const Color warningColor = Color(0xFFF57F17); // Yellow
  static const Color backgroundColor = Color(0xFFFAFAFA); // Light gray
  static const Color cardColor = Color(0xFFFFFFFF); // White

  // Padding & Margins
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeTitle = 24.0;

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration debounceDelay = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 8;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 10;

  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String timeoutErrorMessage = 'Request timed out. Please try again.';
  static const String unknownErrorMessage = 'An unknown error occurred.';

class AppConstants {
  static const String baseUrl =
      String.fromEnvironment('BASE_URL', defaultValue: 'http://10.0.2.2:8000/api/v1');

  static const String tokenKey = 'access_token';
  static const String userIdKey = 'user_id';

  // API Endpoints
  static const String loginEndpoint = '/api/v1/auth/login';
  static const String cropRecommendEndpoint = '/api/v1/crop/recommend';
  static const String yieldPredictEndpoint = '/api/v1/prediction/yield';
  static const String pestPredictEndpoint = '/api/v1/prediction/pest';
  static const String weatherEndpoint = '/api/v1/weather';
  static const String chatbotEndpoint = '/api/v1/chatbot/ask';

}
