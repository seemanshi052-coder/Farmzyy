import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import 'prediction_provider.dart';

class YieldPredictionScreen extends ConsumerWidget {
  const YieldPredictionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yieldAsyncValue = ref.watch(yieldPredictionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yield Prediction'),
        elevation: 0,
      ),
      body: yieldAsyncValue.when(
        data: (prediction) => _buildPredictionView(context, prediction),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppTheme.errorColor, size: 48),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionView(BuildContext context, dynamic prediction) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prediction Card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '🌾',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Yield Forecast',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  Container(
                    padding: const EdgeInsets.all(AppTheme.paddingMedium),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                    child: Text(
                      prediction.prediction,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.green[900],
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),

          // Risk Level & Confidence
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  'Risk Level',
                  prediction.riskLevel,
                  _getRiskColor(prediction.riskLevel),
                ),
              ),
              const SizedBox(width: AppTheme.paddingMedium),
              Expanded(
                child: _buildInfoCard(
                  context,
                  'Confidence',
                  '${(prediction.confidenceScore * 100).toStringAsFixed(0)}%',
                  AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.paddingMedium),

          // Reasoning
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reasoning',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    prediction.reasoning,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),

          // Confidence Progress
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Model Confidence',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusSmall),
                    child: LinearProgressIndicator(
                      value: prediction.confidenceScore,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(prediction.confidenceScore * 100).toStringAsFixed(1)}% confident',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return AppTheme.errorColor;
      case 'medium':
        return AppTheme.warningColor;
      case 'low':
        return AppTheme.successColor;
      default:
        return Colors.grey;
    }
  }
}
