import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import 'dashboard_provider.dart';

/// Market Price Card Widget
class MarketCard extends ConsumerWidget {
  const MarketCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCrop = ref.watch(selectedCropProvider);
    final marketAsyncValue = ref.watch(marketProvider(selectedCrop));

    return marketAsyncValue.when(
      data: (market) => Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with crop selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Market Price',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        market.crop,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _showCropSelector(context, ref),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadiusSmall),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.edit, size: 14),
                          const SizedBox(width: 4),
                          const Text('Change'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.paddingMedium),

              // Price Display
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Price',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Text(
                        '₹${market.currentPrice.toStringAsFixed(2)}/kg',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Trend indicator
                  if (market.trend != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _getTrendColor(market.trend!).withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadiusSmall),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _getTrendIcon(market.trend!),
                            color: _getTrendColor(market.trend!),
                            size: 20,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            market.trend!,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: _getTrendColor(market.trend!),
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          if (market.priceChange != null)
                            Text(
                              '${market.priceChange! > 0 ? '+' : ''}${market.priceChange!.toStringAsFixed(1)}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: _getTrendColor(market.trend!),
                                    fontSize: 10,
                                  ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppTheme.paddingMedium),

              // Forecast price
              if (market.forecastPrice != null)
                Container(
                  padding: const EdgeInsets.all(AppTheme.paddingSmall),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusSmall),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Forecasted Price',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 10,
                                ),
                          ),
                          Text(
                            '₹${market.forecastPrice!.toStringAsFixed(2)}/kg',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.secondaryColor,
                                ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.trending_up,
                        color: AppTheme.secondaryColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      loading: () => Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: SizedBox(
            height: 150,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
      error: (error, stack) => Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                color: AppTheme.errorColor,
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load market data',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.errorColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show crop selector dialog
  void _showCropSelector(BuildContext context, WidgetRef ref) {
    final crops = ['Rice', 'Wheat', 'Corn', 'Sugarcane', 'Cotton'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Crop'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: crops
                .map(
                  (crop) => ListTile(
                    title: Text(crop),
                    onTap: () {
                      ref.read(selectedCropProvider.notifier).state = crop;
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
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

  /// Get trend icon
  IconData _getTrendIcon(String trend) {
    switch (trend.toLowerCase()) {
      case 'increasing':
        return Icons.trending_up;
      case 'decreasing':
        return Icons.trending_down;
      case 'stable':
        return Icons.trending_flat;
      default:
        return Icons.help_outline;
    }
  }
}
