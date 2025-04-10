import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../utils/app_constants.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio;

  ApiService({
    required this.baseUrl,
    Dio? dio,
  }) : _dio = dio ?? _createDio(baseUrl);

  static Dio _createDio(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectionTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
        responseType: ResponseType.json,
      ),
    );

    // Add logging interceptor for development
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));

    return dio;
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options ?? Options(headers: headers),
      );

      return _processResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic data,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        queryParameters: queryParameters,
        data: data,
        options: options ?? Options(headers: headers),
      );

      return _processResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic data,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        queryParameters: queryParameters,
        data: data,
        options: options ?? Options(headers: headers),
      );

      return _processResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic data,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
        data: data,
        options: options ?? Options(headers: headers),
      );

      return _processResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> downloadFile(
    String url,
    String savePath, {
    Map<String, dynamic>? headers,
    Function(int received, int total)? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        options: Options(headers: headers),
      );

      return {'success': true, 'path': savePath};
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Map<String, dynamic> _processResponse(Response response) {
    if (response.statusCode != null && 
        response.statusCode! >= 200 && 
        response.statusCode! < 300) {
      return response.data is Map<String, dynamic> 
          ? response.data 
          : {'data': response.data};
    } else {
      return {
        'error': 'Request failed with status: ${response.statusCode}',
        'body': response.data,
      };
    }
  }

  Map<String, dynamic> _handleDioError(DioException e) {
    String errorMessage;
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = "";
        break;
      case DioExceptionType.badResponse:
        errorMessage = 'Bad response: ${e.response?.statusCode}';
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request was cancelled';
        break;
      case DioExceptionType.connectionError:
        errorMessage = AppConstants.connectionError;
        break;
      default:
        errorMessage = e.message ?? AppConstants.unknownError;
    }

    return {
      'error': errorMessage,
      'status': e.response?.statusCode,
      'data': e.response?.data,
    };
  }
}