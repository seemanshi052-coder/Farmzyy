/// Market Trend Data Model
class MarketTrendData {
  final String crop;
  final double current_price;
  final double forecast_price;
  final String trend;
  final String? unit;
  final double? price_change;

  MarketTrendData({
    required this.crop,
    required this.current_price,
    required this.forecast_price,
    required this.trend,
    this.unit,
    this.price_change,
  });

  factory MarketTrendData.fromJson(Map<String, dynamic> json) {
    return MarketTrendData(
      crop: json['crop'] as String? ?? 'Unknown',
      current_price: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      forecast_price: (json['forecast_price'] as num?)?.toDouble() ?? 0.0,
      trend: json['trend'] as String? ?? 'Stable',
      unit: json['unit'] as String?,
      price_change: (json['price_change'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crop': crop,
      'current_price': current_price,
      'forecast_price': forecast_price,
      'trend': trend,
      'unit': unit,
      'price_change': price_change,
    };
  }

  /// Get trend color
  String getTrendColor() {
    switch (trend.toLowerCase()) {
      case 'increasing':
        return '#388E3C'; // Green
      case 'decreasing':
        return '#D32F2F'; // Red
      case 'stable':
        return '#F57F17'; // Yellow
      default:
        return '#757575'; // Gray
    }
  }

  /// Get trend icon
  String getTrendIcon() {
    switch (trend.toLowerCase()) {
      case 'increasing':
        return '📈';
      case 'decreasing':
        return '📉';
      case 'stable':
        return '➡️';
      default:
        return '❓';
    }
  }
}
