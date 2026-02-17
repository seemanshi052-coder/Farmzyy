import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/api_config.dart';
import '../../utils/app_logger.dart';
import '../../utils/app_exceptions.dart';

/// Standard API Response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final dynamic error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      message: json['message'] as String?,
      error: json['error'],
    );
  }

  bool get isSuccess => success && error == null;
}

/// API Service using Dio
class ApiService {
  late final Dio _dio;
  late final SharedPreferences _prefs;

  ApiService({required SharedPreferences prefs}) : _prefs = prefs {
    _initializeDio();
  }

  /// Initialize Dio with configuration
  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        contentType: 'application/json',
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_LoggingInterceptor());
    _dio.interceptors.add(_AuthInterceptor(_prefs));
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJsonT,
  }) async {
    try {
      AppLogger.info('GET: $endpoint');

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      AppLogger.error('GET Error: ${e.message}');
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('Unexpected error in GET: $e');
      throw ServerException(message: 'Unexpected error occurred');
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    T Function(dynamic)? fromJsonT,
  }) async {
    try {
      AppLogger.info('POST: $endpoint');

      final response = await _dio.post(
        endpoint,
        data: data,
      );

      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      AppLogger.error('POST Error: ${e.message}');
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('Unexpected error in POST: $e');
      throw ServerException(message: 'Unexpected error occurred');
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    T Function(dynamic)? fromJsonT,
  }) async {
    try {
      AppLogger.info('PUT: $endpoint');

      final response = await _dio.put(
        endpoint,
        data: data,
      );

      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      AppLogger.error('PUT Error: ${e.message}');
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('Unexpected error in PUT: $e');
      throw ServerException(message: 'Unexpected error occurred');
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    T Function(dynamic)? fromJsonT,
  }) async {
    try {
      AppLogger.info('DELETE: $endpoint');

      final response = await _dio.delete(
        endpoint,
        data: data,
      );

      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      AppLogger.error('DELETE Error: ${e.message}');
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('Unexpected error in DELETE: $e');
      throw ServerException(message: 'Unexpected error occurred');
    }
  }

  /// Handle API response
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJsonT,
  ) {
    try {
      final statusCode = response.statusCode ?? 500;

      if (statusCode >= 400) {
        AppLogger.error('HTTP Error: $statusCode');
        final errorMessage = _extractErrorMessage(response.data);
        throw ServerException(
          message: errorMessage,
          statusCode: statusCode,
        );
      }

      if (response.data is! Map<String, dynamic>) {
        throw ServerException(message: 'Invalid response format');
      }

      final jsonData = response.data as Map<String, dynamic>;
      final apiResponse = ApiResponse<T>.fromJson(jsonData, fromJsonT);

      if (!apiResponse.isSuccess) {
        final errorMessage = apiResponse.message ?? 'Request failed';
        throw ServerException(message: errorMessage);
      }

      AppLogger.info('Response success: ${apiResponse.data}');
      return apiResponse;
    } catch (e) {
      AppLogger.error('Error handling response: $e');
      rethrow;
    }
  }

  /// Extract error message from response
  String _extractErrorMessage(dynamic responseData) {
    if (responseData == null) return 'Unknown error';

    if (responseData is Map<String, dynamic>) {
      final error = responseData['error'];
      if (error is Map<String, dynamic>) {
        return error['message'] ?? 'Unknown error';
      }
      return responseData['message'] ?? 'Unknown error';
    }

    return 'Unknown error';
  }

  /// Handle DioException
  AppException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutException(message: 'Request timeout');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 500;
        final message = _extractErrorMessage(error.response?.data);
        return ServerException(
          message: message,
          statusCode: statusCode,
        );

      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection');

      default:
        return ServerException(message: error.message ?? 'Unknown error');
    }
  }

  /// Save access token
  Future<void> saveToken(String access_token) async {
    try {
      await _prefs.setString(ApiConfig.tokenKey, access_token);
      AppLogger.info('Token saved');
    } catch (e) {
      AppLogger.error('Error saving token: $e');
    }
  }

  /// Get access token
  String? getToken() {
    try {
      return _prefs.getString(ApiConfig.tokenKey);
    } catch (e) {
      AppLogger.error('Error getting token: $e');
      return null;
    }
  }

  /// Clear access token
  Future<void> clearToken() async {
    try {
      await _prefs.remove(ApiConfig.tokenKey);
      AppLogger.info('Token cleared');
    } catch (e) {
      AppLogger.error('Error clearing token: $e');
    }
  }
}

/// Logging Interceptor
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug('→ ${options.method} ${options.path}');
    AppLogger.debug('  Headers: ${options.headers}');
    if (options.data != null) {
      AppLogger.debug('  Data: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.debug('← ${response.statusCode} ${response.requestOptions.path}');
    AppLogger.debug('  Response: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error('✗ ${err.requestOptions.method} ${err.requestOptions.path}');
    AppLogger.error('  Error: ${err.message}');
    super.onError(err, handler);
  }
}

/// Authorization Interceptor
class _AuthInterceptor extends Interceptor {
  final SharedPreferences _prefs;

  _AuthInterceptor(this._prefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final access_token = _prefs.getString(ApiConfig.tokenKey);
      if (access_token != null && access_token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $access_token';
        AppLogger.debug('Authorization header added');
      }
    } catch (e) {
      AppLogger.error('Error adding auth header: $e');
    }
    super.onRequest(options, handler);
  }
}
