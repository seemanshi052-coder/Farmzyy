import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Unified API service for frontend <-> backend communication.
///
/// Configure backend URL with:
/// flutter run --dart-define=BASE_URL_API_V1=http://10.0.2.2:8000/api/v1
class ApiService {
  ApiService({
    Dio? dio,
    FlutterSecureStorage? storage,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: const String.fromEnvironment(
                  'BASE_URL_API_V1',
                  defaultValue: 'http://10.0.2.2:8000/api/v1',
                ),
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 30),
                sendTimeout: const Duration(seconds: 30),
                contentType: 'application/json',
                responseType: ResponseType.json,
              ),
            ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: _tokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  final FlutterSecureStorage _storage;

  static const String _tokenKey = 'access_token';

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);

  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _asMap(response.data);
    } on DioException catch (e) {
      throw Exception(_errorMessage(e));
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _asMap(response.data);
    } on DioException catch (e) {
      throw Exception(_errorMessage(e));
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    dynamic data,
  }) async {
    try {
      final response = await _dio.put(path, data: data);
      return _asMap(response.data);
    } on DioException catch (e) {
      throw Exception(_errorMessage(e));
    }
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    dynamic data,
  }) async {
    try {
      final response = await _dio.delete(path, data: data);
      return _asMap(response.data);
    } on DioException catch (e) {
      throw Exception(_errorMessage(e));
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    return {'data': data};
  }

  String _errorMessage(DioException e) {
    final responseData = e.response?.data;
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'] ??
          (responseData['error'] is Map<String, dynamic>
              ? responseData['error']['message']
              : null);
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Request timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'Cannot connect to backend. Check BASE_URL_API_V1 and internet.';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode ?? 'unknown'}';
      default:
        return e.message ?? 'Unexpected network error';
    }
  }
}