import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/env_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logger_interceptor.dart';
import 'exceptions/api_exceptions.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.addAll([
      AuthInterceptor(_storage),
      ErrorInterceptor(),
      LoggerInterceptor(),
    ]);
  }

  Future<void> setAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> clearAuthToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Generic request method with type safety
  Future<Response<T>> request<T>({
    required String path,
    required String method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      final response = await dio.request<T>(
        path,
        options: Options(method: method),
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: e.error,
        );
      }
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Exception _handleDioError(DioException error) {
    // This method handles Dio errors *without* a response (network, timeout, cancel, etc.)
    // Errors *with* a response are handled by ErrorInterceptor or rethrown directly from the request method.
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
      case DioExceptionType.cancel:
        return RequestCancelledException();
      // Includes DioExceptionType.connectionError, DioExceptionType.badCertificate, 
      // DioExceptionType.unknown, etc.
      default:
        return NetworkException();
    }
  }
} 