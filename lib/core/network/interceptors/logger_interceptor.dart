import 'package:dio/dio.dart';
import '../../config/env_config.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (EnvConfig.enableLogging) {
      print('┌------------------------------------------------------------------------------');
      print('| Request: ${options.method} ${options.uri}');
      print('| Headers: ${options.headers}');
      print('| Data: ${options.data}');
      print('└------------------------------------------------------------------------------');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (EnvConfig.enableLogging) {
      print('┌------------------------------------------------------------------------------');
      print('| Response: ${response.statusCode} ${response.requestOptions.uri}');
      print('| Data: ${response.data}');
      print('└------------------------------------------------------------------------------');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (EnvConfig.enableLogging) {
      print('┌------------------------------------------------------------------------------');
      print('| Error: ${err.type}');
      print('| ${err.message}');
      print('| ${err.response?.data}');
      print('└------------------------------------------------------------------------------');
    }
    handler.next(err);
  }
} 