import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import 'prediction_provider.dart';

class PriceForecastScreen extends ConsumerStatefulWidget {
  final String? initialCrop;

  const PriceForecastScreen({super.key, this.initialCrop});

  @override
  ConsumerState<PriceForecastScreen> createState() => _PriceForecastScreenState();
}

class _PriceForecastScreenState extends ConsumerState<PriceForecastScreen> {
  late String selectedCrop;

  final List<String> crops = ['Rice', 'Wheat', 'Corn', 'Sugarcane', 'Cotton'];

  @override
  void initState() {
    super.initState();
    selectedCrop = widget.initialCrop ?? 'Rice';
  }

  @override
  Widget build(BuildContext context) {
    final forecastAsyncValue = ref.watch(priceForecastProvider(selectedCrop));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Forecast'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Crop Selector
            _buildCropSelector(),
            const SizedBox(height: AppTheme.paddingLarge),

            // Forecast Display
            forecastAsyncValue.when(
              data: (prediction) => _buildForecastView(context, prediction),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCropSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Crop',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: crops.map((crop) {
            final isSelected = crop == selectedCrop;
            return FilterChip(
              label: Text(crop),
              selected: isSelected,
              onSelected: (val) {
                setState(() => selectedCrop = crop);
              },
              backgroundColor: Colors.white,
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildForecastView(BuildContext context, dynamic prediction) {
    return Column(
      children: [
        // Price Prediction Card
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
                      '💹',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '$selectedCrop Price Forecast',
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
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                  child: Text(
                    prediction.prediction,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[900],
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppTheme.paddingMedium),

        // Confidence & Risk Level
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                'Confidence',
                '${(prediction.confidenceScore * 100).toStringAsFixed(0)}%',
                AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: AppTheme.paddingMedium),
            Expanded(
              child: _buildMetricCard(
                context,
                'Reliability',
                prediction.riskLevel,
                _getRiskColor(prediction.riskLevel),
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
                  'Market Factors',
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
                  'Model Accuracy',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                  child: LinearProgressIndicator(
                    value: prediction.confidenceScore,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(prediction.confidenceScore * 100).toStringAsFixed(1)}% accurate based on historical data',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppTheme.paddingMedium),

        // Disclaimer
        Container(
          padding: const EdgeInsets.all(AppTheme.paddingSmall),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Forecasts are based on historical trends and may vary due to unforeseen events.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.orange[900],
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
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
