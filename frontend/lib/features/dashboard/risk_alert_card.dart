import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../data/models/dashboard_models.dart';
import 'dashboard_provider.dart';

/// Risk Alert Card Widget
class RiskAlertCard extends ConsumerWidget {
  final RiskAlertData? risk;

  const RiskAlertCard({
    super.key,
    this.risk,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (risk != null) {
      return _buildRiskCard(context, risk!);
    }

    // When no specific risk provided, show all alerts
    final risksAsyncValue = ref.watch(riskAlertsProvider);

    return risksAsyncValue.when(
      data: (risks) {
        if (risks.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppTheme.successColor,
                    size: 50,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'All Clear!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.successColor,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No active risk alerts at this moment',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        // Show first alert with "View More" option
        return _buildRiskCard(context, risks.first);
      },
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
                'Failed to load alerts',
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

  /// Build individual risk card
  Widget _buildRiskCard(BuildContext context, RiskAlertData risk) {
    final riskColor = _getRiskColor(risk.riskLevel);

    return Card(
      elevation: 4,
      borderOnForeground: true,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          border: Border(
            left: BorderSide(color: riskColor, width: 4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with risk level badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            risk.getRiskIcon(),
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Risk Alert',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      if (risk.crop != null)
                        Text(
                          'Crop: ${risk.crop}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusSmall),
                    ),
                    child: Text(
                      risk.riskLevel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: riskColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.paddingMedium),

              // Prediction text
              Container(
                padding: const EdgeInsets.all(AppTheme.paddingSmall),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius:
                      BorderRadius.circular(AppTheme.borderRadiusSmall),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prediction',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      risk.prediction,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.paddingSmall),

              // Confidence score
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Confidence Score',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  Text(
                    '${(risk.confidenceScore * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: riskColor,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppTheme.borderRadiusSmall),
                child: LinearProgressIndicator(
                  value: risk.confidenceScore,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: AppTheme.paddingMedium),

              // Reasoning
              if (risk.reasoning != null)
                Container(
                  padding: const EdgeInsets.all(AppTheme.paddingSmall),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusSmall),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why?',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.warningColor,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        risk.reasoning!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                      ),
                    ],
                  ),
                ),

              // Suggested Actions
              if (risk.suggestedActions != null &&
                  risk.suggestedActions!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.paddingMedium),
                    Text(
                      'Suggested Actions',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: risk.suggestedActions!
                          .map(
                            (action) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: 6.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: AppTheme.successColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      action,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey[700],
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get color based on risk level
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
