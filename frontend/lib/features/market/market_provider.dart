import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/api_config.dart';
import '../../data/models/market_models.dart';
import '../../data/services/api_service.dart';
import '../../data/providers/api_service_provider.dart';
import '../../utils/app_logger.dart';

/// Market Trends FutureProvider - GET /market/trends
final marketTrendsProvider = FutureProvider<List<MarketTrendData>>((ref) async {
  try {
    final apiService = await ref.watch(apiServiceProvider.future);

    // Call API endpoint
    final response = await apiService.get<Map<String, dynamic>>(
      ApiConfig.marketTrendsEndpoint,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );

    if (!response.success) {
      AppLogger.error('Market API error: ${response.message}');
      throw Exception(response.message ?? 'Failed to fetch market trends');
    }

    final data = response.data;
    if (data == null) {
      throw Exception('No data received');
    }

    // Extract trends from response.data.data (or response.data['trends'])
    final trendsData = data['trends'] ?? data['data'] ?? [];
    
    if (trendsData is! List) {
      throw Exception('Invalid response format');
    }

    final trends = trendsData
        .map((item) => MarketTrendData.fromJson(item as Map<String, dynamic>))
        .toList();

    AppLogger.info('Successfully fetched ${trends.length} market trends');
    return trends;
  } catch (e) {
    AppLogger.error('Error fetching market trends: $e');
    rethrow;
  }
});

/// Single Market Trend FutureProvider.family - GET /market/trends?crop=Rice
final marketTrendProvider = FutureProvider.family<MarketTrendData, String>((ref, crop) async {
  try {
    final apiService = await ref.watch(apiServiceProvider.future);

    // Call API endpoint with crop parameter
    final response = await apiService.get<Map<String, dynamic>>(
      '${ApiConfig.marketTrendsEndpoint}?crop=$crop',
      fromJsonT: (json) => json as Map<String, dynamic>,
    );

    if (!response.success) {
      AppLogger.error('Market API error for $crop: ${response.message}');
      throw Exception(response.message ?? 'Failed to fetch market trend for $crop');
    }

    final data = response.data;
    if (data == null) {
      throw Exception('No data received');
    }

    final trend = MarketTrendData.fromJson(data);
    AppLogger.info('Successfully fetched market trend for $crop');
    return trend;
  } catch (e) {
    AppLogger.error('Error fetching market trend for $crop: $e');
    rethrow;
  }
});
