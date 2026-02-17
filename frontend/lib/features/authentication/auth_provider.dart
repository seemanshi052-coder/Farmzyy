import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/api_config.dart';
import '../../data/models/auth_models.dart';
import '../../data/providers/api_service_provider.dart';
import '../../data/services/api_service.dart';
import '../../utils/app_logger.dart';

/// Authentication State
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final String? access_token;
  final String? user_id;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.access_token,
    this.user_id,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    String? access_token,
    String? user_id,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      access_token: access_token ?? this.access_token,
      user_id: user_id ?? this.user_id,
    );
  }
}

/// Authentication Provider using Riverpod
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

/// Auth State Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(AuthState());

  /// Request OTP for phone number
  Future<void> requestOtp(String phone) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final apiService = await _ref.watch(apiServiceProvider.future);

      // In a real app, you'd call an OTP endpoint
      // For now, we'll just log the request
      AppLogger.info('Requesting OTP for phone: $phone');

      state = state.copyWith(isLoading: false);
    } catch (e) {
      AppLogger.error('Error requesting OTP: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Login with phone and OTP
  Future<bool> login(String phone, String otp) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final apiService = await _ref.watch(apiServiceProvider.future);

      // Create login request
      final request = LoginRequest(phone: phone, otp: otp);

      AppLogger.info('Logging in with phone: $phone');

      // Make API call to login endpoint
      final response = await apiService.post<LoginResponse>(
        ApiConfig.authLoginEndpoint,
        data: request.toJson(),
        fromJsonT: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );

      if (response.isSuccess && response.data != null) {
        final loginResponse = response.data!;

        // Store tokens
        await apiService.saveToken(loginResponse.access_token);

        AppLogger.info('Login successful. User ID: ${loginResponse.user_id}');

        // Update state
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          access_token: loginResponse.access_token,
          user_id: loginResponse.user_id,
        );

        return true;
      } else {
        final errorMsg = response.message ?? 'Login failed';
        AppLogger.error('Login failed: $errorMsg');
        state = state.copyWith(
          isLoading: false,
          error: errorMsg,
        );
        return false;
      }
    } catch (e) {
      AppLogger.error('Error during login: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);

      final apiService = await _ref.watch(apiServiceProvider.future);
      await apiService.clearToken();

      AppLogger.info('User logged out');

      state = AuthState();
    } catch (e) {
      AppLogger.error('Error during logout: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}
