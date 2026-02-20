import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/prediction_result_card.dart';
import '../models/yield_model.dart';
import '../providers/yield_provider.dart';

class YieldPredictionScreen extends ConsumerStatefulWidget {
  const YieldPredictionScreen({super.key});

  @override
  ConsumerState<YieldPredictionScreen> createState() =>
      _YieldPredictionScreenState();
}

class _YieldPredictionScreenState
    extends ConsumerState<YieldPredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cropCtrl = TextEditingController();
  final _landSizeCtrl = TextEditingController();
  final _fertilizerCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  @override
  void dispose() {
    _cropCtrl.dispose();
    _landSizeCtrl.dispose();
    _fertilizerCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(yieldProvider.notifier).predict(
          YieldPredictRequest(
            crop: _cropCtrl.text.trim(),
            land_size: double.parse(_landSizeCtrl.text),
            fertilizer_usage: double.parse(_fertilizerCtrl.text),
            location: _locationCtrl.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(yieldProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Yield Prediction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoBanner(
              icon: Icons.bar_chart_rounded,
              color: AppTheme.primary,
              title: 'Yield Forecasting',
              subtitle: 'Predict your harvest yield using AI analysis',
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _cropCtrl,
                    validator: (v) => Validators.required(v, 'Crop name'),
                    decoration: const InputDecoration(
                      labelText: 'Crop Name',
                      prefixIcon: Icon(Icons.grass_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _landSizeCtrl,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          validator: Validators.number,
                          decoration: const InputDecoration(
                            labelText: 'Land Size (acres)',
                            prefixIcon: Icon(Icons.square_foot_rounded),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _fertilizerCtrl,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          validator: Validators.number,
                          decoration: const InputDecoration(
                            labelText: 'Fertilizer (kg)',
                            prefixIcon: Icon(Icons.science_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _locationCtrl,
                    validator: (v) => Validators.required(v, 'Location'),
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: state.isLoading ? null : _submit,
                      icon: const Icon(Icons.query_stats_rounded),
                      label: state.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Predict Yield'),
                    ),
                  ),
                ],
              ),
            ),
            if (state.error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(state.error!,
                    style: const TextStyle(color: AppTheme.error)),
              ),
            ],
            if (state.result != null) ...[
              const SizedBox(height: 24),
              PredictionResultCard(
                title: 'Yield Prediction',
                prediction: state.result!.prediction,
                confidenceScore: state.result!.confidence_score,
                icon: Icons.bar_chart_rounded,
                color: AppTheme.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _InfoBanner({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
