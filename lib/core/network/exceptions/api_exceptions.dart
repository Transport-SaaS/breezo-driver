class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException() : super('No internet connection');
}

class TimeoutException extends ApiException {
  TimeoutException() : super('Request timeout');
}

class BadRequestException extends ApiException {
  BadRequestException([String? message]) : super(message ?? 'Bad request');
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super('Unauthorized');
}

class ForbiddenException extends ApiException {
  ForbiddenException() : super('Access denied');
}

class NotFoundException extends ApiException {
  NotFoundException() : super('Resource not found');
}

class ServerException extends ApiException {
  ServerException() : super('Internal server error');
}

class RequestCancelledException extends ApiException {
  RequestCancelledException() : super('Request cancelled');
} 