import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/pest_model.dart';
import '../services/pest_service.dart';

final pestServiceProvider = Provider<PestService>(
  (ref) => PestService(ref.read(apiClientProvider)),
);

class PestState {
  final bool isLoading;
  final PestPredictResult? result;
  final String? error;

  PestState({this.isLoading = false, this.result, this.error});

  PestState copyWith(
      {bool? isLoading, PestPredictResult? result, String? error}) {
    return PestState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error,
    );
  }
}

class PestNotifier extends StateNotifier<PestState> {
  final PestService _service;
  PestNotifier(this._service) : super(PestState());

  Future<void> predict() async {
    state = state.copyWith(isLoading: true, error: null);
    final response = await _service.predict();
    if (response.success) {
      state = state.copyWith(isLoading: false, result: response.data);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.error?.message ?? 'Prediction failed',
      );
    }
  }

  void reset() => state = PestState();
}

final pestProvider = StateNotifierProvider<PestNotifier, PestState>(
  (ref) => PestNotifier(ref.read(pestServiceProvider)),
);
