import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

/// SharedPreferences Provider
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// ApiService Provider - Initialize once and reuse
final apiServiceProvider = FutureProvider<ApiService>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return ApiService(prefs: prefs);
});

/// Async ApiService Provider for use in other providers
/// Use this when you need to make API calls in other providers
final asyncApiServiceProvider = FutureProvider<ApiService>((ref) async {
  return await ref.watch(apiServiceProvider.future);
});
