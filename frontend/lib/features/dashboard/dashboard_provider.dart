import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/dashboard_models.dart';
import '../../data/providers/api_service_provider.dart';

/// Weather Data Provider - Placeholder with mock data
final weatherProvider = FutureProvider<WeatherData>((ref) async {
  // TODO: Connect to API endpoint: GET /weather/current?location=UserLocation
  // For now, return placeholder data
  
  await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
  
  return WeatherData(
    temperature: 28.5,
    humidity: 75.0,
    rainfall: 200.0,
    condition: 'Partly Cloudy',
    windSpeed: 12.5,
    location: 'West Bengal',
  );
});

/// Market Data Provider - Placeholder with mock data
final marketProvider = FutureProvider.family<MarketData, String>((ref, crop) async {
  // TODO: Connect to API endpoint: GET /market/trends?crop=Rice
  // For now, return placeholder data based on crop
  
  await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
  
  return MarketData(
    crop: crop,
    currentPrice: 2200.0,
    forecastPrice: 2350.0,
    trend: 'Increasing',
    priceChange: 6.8,
    unit: '₹/kg',
  );
});

/// Risk Alerts Provider - Placeholder with mock data
final riskAlertsProvider = FutureProvider<List<RiskAlertData>>((ref) async {
  // TODO: Connect to API endpoints:
  // - POST /prediction/pest
  // - POST /prediction/climate
  // - POST /prediction/yield (for prediction risks)
  // For now, return placeholder data
  
  await Future.delayed(const Duration(milliseconds: 800)); // Simulate API call
  
  return [
    RiskAlertData(
      riskType: 'pest',
      riskLevel: 'High',
      crop: 'Rice',
      prediction: 'High humidity increases fungal infection risk',
      confidenceScore: 0.86,
      reasoning: 'Current humidity (75%) is favorable for fungal growth',
      suggestedActions: [
        'Apply fungicide treatment',
        'Improve drainage',
        'Reduce irrigation frequency',
      ],
    ),
    RiskAlertData(
      riskType: 'weather',
      riskLevel: 'Medium',
      crop: 'Rice',
      prediction: 'Heavy rainfall expected',
      confidenceScore: 0.72,
      reasoning: 'Weather forecast shows 60% probability of heavy rain',
      suggestedActions: [
        'Prepare field for drainage',
        'Check irrigation systems',
      ],
    ),
  ];
});

/// Selected Crop Provider (will be set by user)
final selectedCropProvider = StateProvider<String>((ref) {
  return 'Rice'; // Default crop
});

/// Active Risk Alert Provider (selected alert)
final activeRiskAlertProvider = StateProvider<RiskAlertData?>((ref) {
  return null;
});
