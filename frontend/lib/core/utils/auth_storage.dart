import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class AuthStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static Future<void> saveTokens({
    required String accessToken,
    required String userId,
  }) async {
    await Future.wait([
      _storage.write(key: AppConstants.tokenKey, value: accessToken),
      _storage.write(key: AppConstants.userIdKey, value: userId),
    ]);
  }

  static Future<String?> getToken() =>
      _storage.read(key: AppConstants.tokenKey);

  static Future<String?> getUserId() =>
      _storage.read(key: AppConstants.userIdKey);

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
