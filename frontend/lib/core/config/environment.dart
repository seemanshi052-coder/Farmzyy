/// Environment configuration for the FarmZyy app
class Environment {
  // API Configuration
static const String baseUrl = String.fromEnvironment(
    'BASE_URL_API_V1',
    defaultValue: 'http://10.0.2.2:8000/api/v1',
  );


  // Development settings
  static const bool debugMode = true;

  // API Endpoints
  static const String authLoginEndpoint = '/auth/login';
  static const String chatbotEndpoint = '/chatbot/ask';
  static const String cropRecommendEndpoint = '/crop/recommend';
  static const String yieldPredictionEndpoint = '/prediction/yield';
  static const String pestRiskEndpoint = '/prediction/pest';
  static const String climateRiskEndpoint = '/prediction/climate';
  static const String weatherEndpoint = '/weather/current';
  static const String marketTrendsEndpoint = '/market/trends';
  static const String supportRequestEndpoint = '/human_support/request';

  // Token related
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';

  // App metadata
  static const String appName = 'FarmZyy';
  static const String appVersion = '1.0.0';
}
