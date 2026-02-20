import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/api_config.dart';
import '../../data/models/prediction_models.dart';
import '../../data/services/api_service.dart';
import '../../data/providers/api_service_provider.dart';
import '../../utils/app_logger.dart';

/// Yield Prediction FutureProvider
final yieldPredictionProvider = FutureProvider<PredictionData>((ref) async {
  final apiService = ref.watch(apiServiceProvider);

  // TODO: Connect to API endpoint: POST /prediction/yield
  // Request body: { "user_id": user_id, "crop": crop, "land_size": land_size, ... }
  
  // Placeholder: Simulate API call with mock data
  await Future.delayed(const Duration(milliseconds: 800));
  
  return PredictionData(
    prediction: 'Expected yield: 45-50 tons per hectare based on current conditions',
    confidenceScore: 0.87,
    reasoning: 'Based on soil pH (6.8), rainfall (820mm), and nitrogen levels (220kg/ha)',
    riskLevel: 'Low',
  );
});

/// Pest Risk Prediction FutureProvider
final pestRiskProvider = FutureProvider<PredictionData>((ref) async {
  final apiService = ref.watch(apiServiceProvider);

  // TODO: Connect to API endpoint: POST /prediction/pest
  // Request body: { "user_id": user_id, "crop": crop, "location": location, ... }
  
  // Placeholder: Simulate API call with mock data
  await Future.delayed(const Duration(milliseconds: 700));
  
  return PredictionData(
    prediction: 'High risk of Rice Leaf Folder (RLF) infestation in next 2-3 weeks',
    confidenceScore: 0.92,
    reasoning: 'Temperature (28-32°C) and humidity (75-80%) favor pest multiplication',
    riskLevel: 'High',
  );
});

/// Price Forecast FutureProvider with crop parameter
final priceForecastProvider = FutureProvider.family<PredictionData, String>((ref, crop) async {
  final apiService = ref.watch(apiServiceProvider);

  // TODO: Connect to API endpoint: POST /prediction/price
  // Request body: { "user_id": user_id, "crop": crop }
  
  // Placeholder: Simulate API call with mock data
  await Future.delayed(const Duration(milliseconds: 600));
  
  return PredictionData(
    prediction: '$crop prices expected to increase by 12-15% in next month',
    confidenceScore: 0.79,
    reasoning: 'Seasonal demand spike + supply constraint from neighboring states',
    riskLevel: 'Low',
  );
});
