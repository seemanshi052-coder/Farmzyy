import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import 'dashboard_provider.dart';

/// Weather Card Widget
class WeatherCard extends ConsumerWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsyncValue = ref.watch(weatherProvider);

    return weatherAsyncValue.when(
      data: (weather) => Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Weather',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        weather.location,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  Icon(
                    weather.condition?.toLowerCase().contains('rain') ?? false
                        ? Icons.cloud_queue
                        : Icons.wb_sunny,
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.paddingMedium),

              // Temperature Display
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.temperature.toStringAsFixed(1)}°C',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                      ),
                      Text(
                        weather.condition ?? 'N/A',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Weather Grid
                  Column(
                    children: [
                      _buildWeatherMetric(
                        context,
                        icon: Icons.opacity,
                        label: 'Humidity',
                        value: '${weather.humidity.toStringAsFixed(0)}%',
                      ),
                      const SizedBox(height: 8),
                      _buildWeatherMetric(
                        context,
                        icon: Icons.water_drop,
                        label: 'Rainfall',
                        value: '${weather.rainfall.toStringAsFixed(1)}mm',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.paddingMedium),

              // Wind Speed
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingSmall,
                  vertical: AppTheme.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius:
                      BorderRadius.circular(AppTheme.borderRadiusSmall),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.air, size: 18, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Wind Speed: ${weather.windSpeed?.toStringAsFixed(1) ?? 'N/A'} km/h',
                      style: Theme.of(context).textTheme.bodySmall,
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
                'Failed to load weather',
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

  /// Build weather metric widget
  Widget _buildWeatherMetric(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontSize: 10,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
        ),
      ],
    );
  }
}
