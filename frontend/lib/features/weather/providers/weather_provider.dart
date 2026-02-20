import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

final weatherServiceProvider = Provider<WeatherService>(
  (ref) => WeatherService(ref.read(apiClientProvider)),
);

class WeatherState {
  final bool isLoading;
  final WeatherData? data;
  final String? error;
  final String location;

  WeatherState({
    this.isLoading = false,
    this.data,
    this.error,
    this.location = 'Delhi',
  });

  WeatherState copyWith({
    bool? isLoading,
    WeatherData? data,
    String? error,
    String? location,
  }) {
    return WeatherState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
      location: location ?? this.location,
    );
  }
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherService _service;
  WeatherNotifier(this._service) : super(WeatherState());

  Future<void> fetchWeather(String location) async {
    state = state.copyWith(isLoading: true, error: null, location: location);
    final response = await _service.getWeather(location);
    if (response.success) {
      state = state.copyWith(isLoading: false, data: response.data);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.error?.message ?? 'Failed to fetch weather',
      );
    }
  }
}

final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>(
  (ref) => WeatherNotifier(ref.read(weatherServiceProvider)),
);
