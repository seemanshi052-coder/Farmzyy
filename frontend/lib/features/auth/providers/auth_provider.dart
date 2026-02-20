import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/utils/auth_storage.dart';
import '../models/auth_model.dart';
import '../services/auth_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.read(apiClientProvider)),
);

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? userId;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.userId,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? userId,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _service;

  AuthNotifier(this._service) : super(AuthState());

  Future<void> checkAuth() async {
    final isLoggedIn = await AuthStorage.isLoggedIn();
    final userId = await AuthStorage.getUserId();
    state = state.copyWith(
      isAuthenticated: isLoggedIn,
      userId: userId,
    );
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    final response = await _service.login(
      LoginRequest(username: username, password: password),
    );
    if (response.success && response.data != null) {
      final auth = response.data!;
      await AuthStorage.saveTokens(
        accessToken: auth.access_token,
        userId: auth.user_id,
      );
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userId: auth.user_id,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.error?.message ?? 'Login failed',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await AuthStorage.clearAll();
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authServiceProvider)),
);
