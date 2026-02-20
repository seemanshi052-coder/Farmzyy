import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/weather_provider.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  final _locationCtrl = TextEditingController(text: 'Delhi');

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(weatherProvider.notifier).fetchWeather('Delhi'),
    );
  }

  @override
  void dispose() {
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Weather Intelligence')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _locationCtrl,
                    decoration: InputDecoration(
                      hintText: 'Enter location...',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search_rounded),
                        onPressed: () => ref
                            .read(weatherProvider.notifier)
                            .fetchWeather(_locationCtrl.text.trim()),
                      ),
                    ),
                    onSubmitted: (v) =>
                        ref.read(weatherProvider.notifier).fetchWeather(v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (state.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (state.error != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(state.error!,
                    style: const TextStyle(color: AppTheme.error)),
              )
            else if (state.data != null) ...[
              // Main weather card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A90D9), Color(0xFF7EC8E3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A90D9).withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.data!.temperature.toStringAsFixed(1)}°C',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 64,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded,
                                    color: Colors.white70, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  state.location,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.wb_sunny_rounded,
                          color: Colors.white,
                          size: 72,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Detail cards row
              Row(
                children: [
                  Expanded(
                    child: _WeatherDetailCard(
                      icon: Icons.water_drop_rounded,
                      iconColor: const Color(0xFF4A90D9),
                      label: 'Humidity',
                      value:
                          '${state.data!.humidity.toStringAsFixed(1)}%',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _WeatherDetailCard(
                      icon: Icons.cloudy_snowing,
                      iconColor: const Color(0xFF457B9D),
                      label: 'Rainfall',
                      value:
                          '${state.data!.rainfall.toStringAsFixed(1)} mm',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Agricultural advice
              _AgricultureAdviceCard(weather: state.data!),
            ],
          ],
        ),
      ),
    );
  }
}

class _WeatherDetailCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _WeatherDetailCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 12),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontSize: 24)),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _AgricultureAdviceCard extends StatelessWidget {
  final dynamic weather;
  const _AgricultureAdviceCard({required this.weather});

  String _getAdvice() {
    if (weather.rainfall > 50) {
      return 'High rainfall detected. Avoid field operations and check drainage systems.';
    } else if (weather.humidity > 80) {
      return 'High humidity may increase fungal disease risk. Monitor crops closely.';
    } else if (weather.temperature > 35) {
      return 'High temperature stress possible. Ensure adequate irrigation for crops.';
    }
    return 'Weather conditions are favorable for most agricultural activities today.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.success.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_rounded, color: AppTheme.success, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Agricultural Advice',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppTheme.success,
                  ),
                ),
                const SizedBox(height: 4),
                Text(_getAdvice(),
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
