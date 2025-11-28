/// HTTP client using Dio with interceptors
library;

import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../error/exceptions.dart';

/// API client for making HTTP requests
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConfig.apiTimeout,
        receiveTimeout: AppConfig.apiTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  /// Inject a token for authentication
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear authentication token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

/// Interceptor for adding auth token to requests
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Token is already set in options.headers when setAuthToken is called
    handler.next(options);
  }
}

/// Interceptor for logging requests and responses
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppConfig.environment == Environment.development) {
      _log('REQUEST', '${options.method} ${options.uri}');
      if (options.data != null) {
        _log('BODY', options.data.toString());
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (AppConfig.environment == Environment.development) {
      _log('RESPONSE', '${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppConfig.environment == Environment.development) {
      _log('ERROR', '${err.response?.statusCode} ${err.requestOptions.uri}');
      _log('MESSAGE', err.message ?? 'Unknown error');
    }
    handler.next(err);
  }

  void _log(String tag, String message) {
    // Using print for development logging - replace with logger in production
    // ignore: avoid_print
    print('[$tag] $message');
  }
}

/// Interceptor for handling errors
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapDioError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        response: err.response,
        type: err.type,
      ),
    );
  }

  NetworkException _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException.timeout();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractErrorMessage(error.response?.data);
        if (statusCode != null) {
          return NetworkException.fromStatusCode(statusCode, message);
        }
        return NetworkException.serverError(message);

      case DioExceptionType.cancel:
        return const NetworkException(
          message: 'Request was cancelled',
          code: 'cancelled',
        );

      case DioExceptionType.connectionError:
        return NetworkException.noConnection();

      case DioExceptionType.badCertificate:
        return const NetworkException(
          message: 'Invalid SSL certificate',
          code: 'bad_certificate',
        );

      case DioExceptionType.unknown:
      default:
        if (error.error.toString().contains('SocketException')) {
          return NetworkException.noConnection();
        }
        return NetworkException.serverError();
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          data['msg']?.toString();
    }
    if (data is String) return data;
    return null;
  }
}
