import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/prediction_result_card.dart';
import '../models/crop_model.dart';
import '../providers/crop_provider.dart';

class CropRecommendationScreen extends ConsumerStatefulWidget {
  const CropRecommendationScreen({super.key});

  @override
  ConsumerState<CropRecommendationScreen> createState() =>
      _CropRecommendationScreenState();
}

class _CropRecommendationScreenState
    extends ConsumerState<CropRecommendationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nitrogenCtrl = TextEditingController();
  final _phosphorusCtrl = TextEditingController();
  final _potassiumCtrl = TextEditingController();
  final _phCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  @override
  void dispose() {
    _nitrogenCtrl.dispose();
    _phosphorusCtrl.dispose();
    _potassiumCtrl.dispose();
    _phCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(cropProvider.notifier).recommend(
          CropRecommendRequest(
            nitrogen: double.parse(_nitrogenCtrl.text),
            phosphorus: double.parse(_phosphorusCtrl.text),
            potassium: double.parse(_potassiumCtrl.text),
            ph: double.parse(_phCtrl.text),
            location: _locationCtrl.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cropProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Recommendation'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderCard(
              icon: Icons.grass_rounded,
              color: AppTheme.success,
              title: 'Soil Analysis',
              subtitle: 'Enter your soil parameters to get the best crop recommendation',
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _InputField(
                          controller: _nitrogenCtrl,
                          label: 'Nitrogen (N)',
                          hint: 'mg/kg',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InputField(
                          controller: _phosphorusCtrl,
                          label: 'Phosphorus (P)',
                          hint: 'mg/kg',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _InputField(
                          controller: _potassiumCtrl,
                          label: 'Potassium (K)',
                          hint: 'mg/kg',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InputField(
                          controller: _phCtrl,
                          label: 'Soil pH',
                          hint: '0 - 14',
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
                      icon: const Icon(Icons.auto_awesome_rounded),
                      label: state.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Get Recommendation'),
                    ),
                  ),
                ],
              ),
            ),
            if (state.error != null) ...[
              const SizedBox(height: 16),
              _ErrorBanner(message: state.error!),
            ],
            if (state.result != null) ...[
              const SizedBox(height: 24),
              PredictionResultCard(
                title: 'Recommended Crop',
                prediction: state.result!.prediction,
                confidenceScore: state.result!.confidence_score,
                icon: Icons.grass_rounded,
                color: AppTheme.success,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: Validators.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _HeaderCard({
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: const TextStyle(color: AppTheme.error, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
