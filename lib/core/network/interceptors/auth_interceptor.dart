import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../config/api_endpoints.dart';
import '../../storage/secure_storage.dart';
class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;
  final Dio _tokenDio = Dio();
  bool _isRefreshing = false;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      if (!_isRefreshing) {
        try {
          _isRefreshing = true;
          final newToken = await _refreshToken();

          if (newToken != null) {
            // Retry the original request with new token
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';

            final response = await _tokenDio.fetch(options);
            return handler.resolve(response);
          }
        } catch (e) {
          // If refresh token fails, logout user
          await _secureStorage.clearTokens();
          // You might want to navigate to login screen here
        } finally {
          _isRefreshing = false;
        }
      }
    }

    return handler.next(err);
  }

  Future<String?> _refreshToken() async {
    final refreshToken = await _secureStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      final response = await _tokenDio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.refreshToken}',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        await _secureStorage.saveAccessToken(newAccessToken);
        await _secureStorage.saveRefreshToken(newRefreshToken);

        return newAccessToken;
      }
    } catch (e) {
      // Refresh token is invalid or expired
    }

    return null;
  }
}
