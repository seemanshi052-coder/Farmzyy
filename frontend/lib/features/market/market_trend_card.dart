import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/models/market_models.dart';

/// Reusable Market Trend Card Widget
class MarketTrendCard extends StatelessWidget {
  final MarketTrendData trend;

  const MarketTrendCard({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    final trendColor = _getTrendColor(trend.trend);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Crop name and trend icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    trend.crop,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: trendColor.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusSmall),
                  ),
                  child: Row(
                    children: [
                      Text(
                        trend.getTrendIcon(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend.trend,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: trendColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.paddingMedium),

            // Price information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPriceColumn(
                  context,
                  'Current Price',
                  '₹${trend.current_price.toStringAsFixed(2)}',
                  Colors.grey[600],
                ),
                _buildDivider(),
                _buildPriceColumn(
                  context,
                  'Forecast Price',
                  '₹${trend.forecast_price.toStringAsFixed(2)}',
                  trendColor,
                ),
                if (trend.price_change != null) ...[
                  _buildDivider(),
                  _buildPriceColumn(
                    context,
                    'Change',
                    '${trend.price_change!.toStringAsFixed(1)}%',
                    trendColor,
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppTheme.paddingSmall),

            // Unit info
            if (trend.unit != null)
              Text(
                'Unit: ${trend.unit}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),

            // Trend bar
            const SizedBox(height: AppTheme.paddingMedium),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              child: LinearProgressIndicator(
                value: _calculateTrendValue(),
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(trendColor),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build price column
  Widget _buildPriceColumn(
    BuildContext context,
    String label,
    String price,
    Color? color,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Build divider
  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.grey[300],
    );
  }

  /// Calculate trend progress value
  double _calculateTrendValue() {
    if (trend.current_price == 0) return 0.5;
    final ratio = trend.forecast_price / trend.current_price;
    return (ratio - 0.5).clamp(0.0, 1.0);
  }

  /// Get trend color
  Color _getTrendColor(String trend) {
    switch (trend.toLowerCase()) {
      case 'increasing':
        return AppTheme.successColor;
      case 'decreasing':
        return AppTheme.errorColor;
      case 'stable':
        return AppTheme.warningColor;
      default:
        return Colors.grey;
    }
  }
}
