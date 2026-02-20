import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/yield_model.dart';
import '../services/yield_service.dart';

final yieldServiceProvider = Provider<YieldService>(
  (ref) => YieldService(ref.read(apiClientProvider)),
);

class YieldState {
  final bool isLoading;
  final YieldPredictResult? result;
  final String? error;

  YieldState({this.isLoading = false, this.result, this.error});

  YieldState copyWith(
      {bool? isLoading, YieldPredictResult? result, String? error}) {
    return YieldState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error,
    );
  }
}

class YieldNotifier extends StateNotifier<YieldState> {
  final YieldService _service;
  YieldNotifier(this._service) : super(YieldState());

  Future<void> predict(YieldPredictRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    final response = await _service.predict(request);
    if (response.success) {
      state = state.copyWith(isLoading: false, result: response.data);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.error?.message ?? 'Prediction failed',
      );
    }
  }

  void reset() => state = YieldState();
}

final yieldProvider = StateNotifierProvider<YieldNotifier, YieldState>(
  (ref) => YieldNotifier(ref.read(yieldServiceProvider)),
);
