/// Weather Data Model
class WeatherData {
  final double temperature;      // in Celsius
  final double humidity;         // in percentage
  final double rainfall;         // in mm
  final String? condition;       // e.g., "Sunny", "Rainy"
  final double? windSpeed;       // in km/h
  final String location;         // Location name

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.rainfall,
    this.condition,
    this.windSpeed,
    required this.location,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['humidity'] as num?)?.toDouble() ?? 0.0,
      rainfall: (json['rainfall'] as num?)?.toDouble() ?? 0.0,
      condition: json['condition'] as String?,
      windSpeed: (json['wind_speed'] as num?)?.toDouble(),
      location: json['location'] as String? ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'rainfall': rainfall,
      'condition': condition,
      'wind_speed': windSpeed,
      'location': location,
    };
  }
}

/// Market Price Data Model
class MarketData {
  final String crop;
  final double currentPrice;     // Current market price
  final double? forecastPrice;   // Predicted price
  final String? trend;           // "Increasing", "Decreasing", "Stable"
  final double? priceChange;     // Price change percentage
  final String? unit;            // e.g., "₹/kg"

  MarketData({
    required this.crop,
    required this.currentPrice,
    this.forecastPrice,
    this.trend,
    this.priceChange,
    this.unit,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      crop: json['crop'] as String? ?? 'Unknown',
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      forecastPrice: (json['forecast_price'] as num?)?.toDouble(),
      trend: json['trend'] as String?,
      priceChange: (json['price_change'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crop': crop,
      'current_price': currentPrice,
      'forecast_price': forecastPrice,
      'trend': trend,
      'price_change': priceChange,
      'unit': unit,
    };
  }
}

/// Risk Alert Data Model
class RiskAlertData {
  final String riskType;              // "pest", "weather", "climate"
  final String riskLevel;             // "High", "Medium", "Low"
  final String? crop;
  final String prediction;            // Prediction text
  final double confidenceScore;       // 0.0 to 1.0
  final String? reasoning;            // Explanation
  final List<String>? suggestedActions; // Recommended actions

  RiskAlertData({
    required this.riskType,
    required this.riskLevel,
    this.crop,
    required this.prediction,
    required this.confidenceScore,
    this.reasoning,
    this.suggestedActions,
  });

  factory RiskAlertData.fromJson(Map<String, dynamic> json) {
    return RiskAlertData(
      riskType: json['risk_type'] as String? ?? 'unknown',
      riskLevel: json['risk_level'] as String? ?? 'Low',
      crop: json['crop'] as String?,
      prediction: json['prediction'] as String? ?? 'No prediction',
      confidenceScore: (json['confidence_score'] as num?)?.toDouble() ?? 0.0,
      reasoning: json['reasoning'] as String?,
      suggestedActions: json['suggested_actions'] != null
          ? List<String>.from(json['suggested_actions'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'risk_type': riskType,
      'risk_level': riskLevel,
      'crop': crop,
      'prediction': prediction,
      'confidence_score': confidenceScore,
      'reasoning': reasoning,
      'suggested_actions': suggestedActions,
    };
  }

  /// Get color based on risk level
  String getRiskColor() {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return '#D32F2F'; // Red
      case 'medium':
        return '#F57F17'; // Yellow
      case 'low':
        return '#388E3C'; // Green
      default:
        return '#757575'; // Gray
    }
  }

  /// Get icon based on risk type
  String getRiskIcon() {
    switch (riskType.toLowerCase()) {
      case 'pest':
        return '🐛';
      case 'weather':
        return '🌦️';
      case 'climate':
        return '🌡️';
      default:
        return '⚠️';
    }
  }
}
