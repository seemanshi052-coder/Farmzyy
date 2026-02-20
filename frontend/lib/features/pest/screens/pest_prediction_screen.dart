import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/pest_provider.dart';

class PestPredictionScreen extends ConsumerWidget {
  const PestPredictionScreen({super.key});

  Color _riskColor(String level) {
    switch (level.toLowerCase()) {
      case 'high':
        return AppTheme.error;
      case 'medium':
        return AppTheme.warning;
      default:
        return AppTheme.success;
    }
  }

  IconData _riskIcon(String level) {
    switch (level.toLowerCase()) {
      case 'high':
        return Icons.warning_rounded;
      case 'medium':
        return Icons.info_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pestProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pest Detection')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4A017), Color(0xFFF4A261)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4A017).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.bug_report_rounded,
                      color: Colors.white, size: 36),
                  const SizedBox(height: 12),
                  Text(
                    'AI Pest Detection',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Analyze your field for pest threats using our ML model',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () => ref.read(pestProvider.notifier).predict(),
                icon: const Icon(Icons.search_rounded),
                label: state.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Run Pest Analysis'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4A017),
                ),
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.cardShadow,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _riskIcon(state.result!.risk_level),
                          color: _riskColor(state.result!.risk_level),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text('Analysis Result',
                            style: Theme.of(context).textTheme.headlineMedium),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _ResultRow(
                      label: 'Detected Pest',
                      value: state.result!.prediction,
                      valueColor: AppTheme.textPrimary,
                    ),
                    const Divider(height: 20),
                    _ResultRow(
                      label: 'Risk Level',
                      value: state.result!.risk_level.toUpperCase(),
                      valueColor: _riskColor(state.result!.risk_level),
                    ),
                    const Divider(height: 20),
                    _ResultRow(
                      label: 'Confidence',
                      value:
                          '${(state.result!.confidence_score * 100).toStringAsFixed(1)}%',
                      valueColor: AppTheme.primary,
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: state.result!.confidence_score,
                        backgroundColor:
                            AppTheme.accent.withOpacity(0.3),
                        color: AppTheme.primary,
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
