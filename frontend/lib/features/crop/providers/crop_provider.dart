import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../models/crop_model.dart';
import '../services/crop_service.dart';

final cropServiceProvider = Provider<CropService>(
  (ref) => CropService(ref.read(apiClientProvider)),
);

class CropState {
  final bool isLoading;
  final CropRecommendResult? result;
  final String? error;

  CropState({this.isLoading = false, this.result, this.error});

  CropState copyWith(
      {bool? isLoading, CropRecommendResult? result, String? error}) {
    return CropState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error,
    );
  }
}

class CropNotifier extends StateNotifier<CropState> {
  final CropService _service;
  CropNotifier(this._service) : super(CropState());

  Future<void> recommend(CropRecommendRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    final response = await _service.recommend(request);
    if (response.success) {
      state = state.copyWith(isLoading: false, result: response.data);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.error?.message ?? 'Failed to get recommendation',
      );
    }
  }

  void reset() => state = CropState();
}

final cropProvider = StateNotifierProvider<CropNotifier, CropState>(
  (ref) => CropNotifier(ref.read(cropServiceProvider)),
);
