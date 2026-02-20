import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/environment.dart';
import '../../utils/app_exceptions.dart';
import '../../utils/app_logger.dart';

/// Base HTTP service for API calls
class ApiService {
  late Dio _dio;
  late SharedPreferences _prefs;

  ApiService() {
    _initializeDio();
  }

  /// Initialize Dio with base options and interceptors
  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Environment.apiBaseUrl,
        connectTimeout: Environment.apiTimeout,
        receiveTimeout: Environment.apiTimeout,
        responseType: ResponseType.json,
        contentType: 'application/json',
      ),
    );

    // Add logging interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.debug('API Request: ${options.method} ${options.path}');
          AppLogger.debug('Headers: ${options.headers}');
          if (options.data != null) {
            AppLogger.debug('Request Body: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.debug('API Response: ${response.statusCode} ${response.requestPath}');
          AppLogger.debug('Response: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          AppLogger.error('API Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );

    // Add token interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  /// Initialize SharedPreferences
  Future<void> initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get stored JWT token
  Future<String?> _getToken() async {
    try {
      return _prefs.getString(Environment.tokenKey);
    } catch (e) {
      AppLogger.error('Error retrieving token: $e');
      return null;
    }
  }

  /// Save JWT token
  Future<void> saveToken(String token) async {
    try {
      await _prefs.setString(Environment.tokenKey, token);
      AppLogger.info('Token saved successfully');
    } catch (e) {
      AppLogger.error('Error saving token: $e');
      throw CacheException(
        message: 'Failed to save token',
        originalError: e,
      );
    }
  }

  /// Clear stored token
  Future<void> clearToken() async {
    try {
      await _prefs.remove(Environment.tokenKey);
      AppLogger.info('Token cleared successfully');
    } catch (e) {
      AppLogger.error('Error clearing token: $e');
      throw CacheException(
        message: 'Failed to clear token',
        originalError: e,
      );
    }
  }

  /// GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      AppLogger.error('Unexpected error in GET request: $e');
      throw AppException(message: 'Unexpected error occurred', originalError: e) as AppException;
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    dynamic data,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      AppLogger.error('Unexpected error in POST request: $e');
      throw AppException(message: 'Unexpected error occurred', originalError: e) as AppException;
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    dynamic data,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      AppLogger.error('Unexpected error in PUT request: $e');
      throw AppException(message: 'Unexpected error occurred', originalError: e) as AppException;
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    dynamic data,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      AppLogger.error('Unexpected error in DELETE request: $e');
      throw AppException(message: 'Unexpected error occurred', originalError: e) as AppException;
    }
  }

  /// Handle successful response
  Map<String, dynamic> _handleResponse(Response response) {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = response.data is Map<String, dynamic>
            ? response.data
            : {'data': response.data};
        return responseData;
      } else {
        throw ServerException(
          message: 'Server returned status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      AppLogger.error('Error handling response: $e');
      rethrow;
    }
  }

  /// Handle DioException
  AppException _handleDioError(DioException error) {
    AppLogger.error('DioException: ${error.type} - ${error.message}');

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutException(
          message: 'Request timed out',
          originalError: error,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return AuthException(
            message: 'Unauthorized access',
            originalError: error,
          );
        }
        return ServerException(
          message: error.response?.data['error']?['message'] ?? 'Server error',
          statusCode: statusCode,
          originalError: error,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection',
          originalError: error,
        );
      default:
        return NetworkException(
          message: error.message ?? 'Network error',
          originalError: error,
        );
    }
  }
}
