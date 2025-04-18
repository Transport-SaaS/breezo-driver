import 'package:dio/dio.dart';
import '../exceptions/api_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Exception customError;
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        customError = TimeoutException();
        break;
      case DioExceptionType.badResponse:
        customError = _handleBadResponse(err.response!);
        break;
      default:
        customError = NetworkException();
    }
    
    final newError = DioException(
      requestOptions: err.requestOptions,
      error: customError,
      type: err.type,
      response: err.response,
    );
    handler.next(newError);
  }

  Exception _handleBadResponse(Response response) {
    switch (response.statusCode) {
      case 400:
        return BadRequestException(response.data?['message']);
      case 401:
        return UnauthorizedException();
      case 403:
        return ForbiddenException();
      case 404:
        return NotFoundException();
      case 500:
        return ServerException();
      default:
        return ApiException(
          'Error occurred with status code: ${response.statusCode}',
        );
    }
  }
} 