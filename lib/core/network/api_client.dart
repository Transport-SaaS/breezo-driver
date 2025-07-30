import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_endpoints.dart';
import '../config/env_config.dart';
import '../storage/secure_storage.dart';
import 'api_error.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logger_interceptor.dart';
import 'exceptions/api_exceptions.dart';

class ApiClient {
  late final Dio _dio;
  final SecureStorage _secureStorage;

  ApiClient({required SecureStorage secureStorage})
      : _secureStorage = secureStorage {
    _initDio();
  }

  void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        // 'Content-Type': 'application/json',
        'Accept': '*/*',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(AuthInterceptor(_secureStorage));

    // Only add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LoggerInterceptor());
    }
  }

  // Generic GET request - Returns the full Dio Response object
  // Generic GET request - Returns the full Dio Response<dynamic> object
  Future<Response<dynamic>> get({ // Removed <T> generic type here
    required String endpoint,
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      );
      // Simply return the raw response object from Dio.
      // The caller is responsible for checking response.statusCode and response.data type.
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST request - Returns the full Dio Response object
  // Generic POST request - Returns the full Dio Response<dynamic> object
  Future<Response<dynamic>> post({ // Removed <T> generic type here
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      );
      // Simply return the raw response object from Dio.
      // The caller is responsible for checking response.statusCode and response.data type.
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic PUT request
  Future<T> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic DELETE request
  Future<T> delete<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  ApiError _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return ApiError(
        message: 'Connection timeout. Please check your internet connection.',
        statusCode: error.response?.statusCode,
        data: error.response?.data,
      );
    } else if (error.type == DioExceptionType.badResponse) {
      return ApiError(
        message: error.response?.data['message'] ?? 'Server error occurred',
        statusCode: error.response?.statusCode,
        data: error.response?.data,
      );
    } else if (error.type == DioExceptionType.cancel) {
      return ApiError(
        message: 'Request was cancelled',
        statusCode: error.response?.statusCode,
        data: error.response?.data,
      );
    } else {
      return ApiError(
        message: 'Network error occurred. Please check your connection.',
        statusCode: error.response?.statusCode,
        data: error.response?.data,
      );
    }
  }
}