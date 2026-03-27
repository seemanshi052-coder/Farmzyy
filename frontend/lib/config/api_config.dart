/// API Configuration
class ApiConfig {
  // Base URL - Change this to your backend URL
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL_API_V1',
    defaultValue: 'http://10.0.2.2:8000/api/v1',
  );

  // API Endpoints
  static const String authLoginEndpoint = '/auth/login';
  
  // Chatbot endpoints
  static const String chatbotAskEndpoint = '/chatbot/ask';
  
  // Crop endpoints
  static const String cropRecommendEndpoint = '/crop/recommend';
  
  // Prediction endpoints
  static const String yieldPredictionEndpoint = '/prediction/yield';
  static const String pestRiskEndpoint = '/prediction/pest';
  static const String climateRiskEndpoint = '/prediction/climate';
  static const String priceForecastEndpoint = '/prediction/price';
  
  // Weather endpoints
  static const String weatherCurrentEndpoint = '/weather/current';
  
  // Market endpoints
  static const String marketTrendsEndpoint = '/market/trends';
  
  // Support endpoints
  static const String supportRequestEndpoint = '/human_support/request';

  // Token keys
  static const String tokenKey = 'access_token';
  static const String userIdKey = 'user_id';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
