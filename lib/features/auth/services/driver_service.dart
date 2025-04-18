import 'package:breezodriver/core/network/api_client.dart';
import 'package:breezodriver/core/network/exceptions/api_exceptions.dart';
import 'package:dio/dio.dart';

class DriverService {
  final ApiClient _apiClient;

  DriverService(this._apiClient);

  Future<Map<String, dynamic>> getDriverStatus() async {
    try {
      final Response response = await _apiClient.request(
        path: '/driver/getDriver',
        method: 'GET',
      );
      // Assuming the response data is the map we need
      return response.data as Map<String, dynamic>; 
    } on DioException catch (e) {
      // Let the ErrorInterceptor handle API errors based on status code
      // Rethrow other Dio errors (network, timeout etc.)
      if (e.error is ApiException) {
        rethrow;
      }
      throw e; // Or handle specific Dio errors differently if needed
    } catch (e) {
      // Handle unexpected errors
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getDriverProfile() async {
    try {
      final Response response = await _apiClient.request(
        path: '/driver/getProfile',
        method: 'GET',
      );
      // Assuming the response data is the map we need
      return response.data as Map<String, dynamic>?;
    } on DioException catch (e) {
      // Check if the error stems from a 404 handled by ErrorInterceptor
      if (e.error is NotFoundException) {
        return null; 
      }
      // Let ErrorInterceptor handle other API errors
      // Rethrow other Dio errors (network, timeout etc.)
       if (e.error is ApiException) {
        rethrow;
      }
      throw e; // Or handle specific Dio errors differently if needed
    } catch (e) {
       // Handle unexpected errors
      rethrow;
    }
  }
} 