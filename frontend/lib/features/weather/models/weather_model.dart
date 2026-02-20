class WeatherData {
  final double temperature;
  final double humidity;
  final double rainfall;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.rainfall,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      rainfall: (json['rainfall'] as num).toDouble(),
    );
  }
}
