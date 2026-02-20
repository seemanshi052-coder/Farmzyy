class AppConstants {
  static const String baseUrl =
      String.fromEnvironment('BASE_URL', defaultValue: 'http://localhost:8000');

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
