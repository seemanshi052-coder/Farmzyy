import '../../../core/api/api_client.dart';
import '../../../core/api/api_response.dart';
import '../../../core/constants/app_constants.dart';
import '../models/weather_model.dart';

class WeatherService {
  final ApiClient _client;
  WeatherService(this._client);

  Future<ApiResponse<WeatherData>> getWeather(String location) {
    return _client.get<WeatherData>(
      AppConstants.weatherEndpoint,
      queryParameters: {'location': location},
      fromJson: (json) => WeatherData.fromJson(json),
    );
  }
}
