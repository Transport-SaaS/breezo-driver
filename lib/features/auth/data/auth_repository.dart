import 'dart:convert';
import 'dart:developer';

import 'package:breezodriver/core/config/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;

  AuthRepository({
    required ApiClient apiClient,
    required SecureStorage secureStorage,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage;

  // New OTP methods
  Future<Map<String, dynamic>> generateOTP({required String phone}) async {
    try {
      final response = await _apiClient.get(
        endpoint: ApiEndpoints.generateOTP,
        queryParams: {'phone': phone},
      );
      
      // Access data from the Response object
      final responseData = response.data;

      // Handle different response types based on responseData
      if (responseData is Map<String, dynamic>) {
        return responseData;
      } else if (responseData is int || responseData is bool) {
        // If response is a simple type like int or bool, wrap it
        return {'success': true, 'data': responseData};
      } else if (responseData == null) {
        return {'success': true};
      } else {
        // For any other type, convert to string and wrap
        return {'success': true, 'data': responseData.toString()};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    try {
      // Expect the full Response object to access headers
      // Call ApiClient.get without type argument
      final response = await _apiClient.get(
        endpoint: ApiEndpoints.verifyOTP,
        queryParams: {
          'phone': phoneNumber,
          'otp': otp,
        },
      );

      // Check for successful status code (e.g., 200 OK)
      if (response.statusCode == 200) {
        // Access the response body
        final responseBody = response.data;

        // Check if body indicates success (adjust key 'status' if needed)
        // Check if body is a Map and indicates success
        if (responseBody is Map<String, dynamic> && responseBody['status'] == 'success') {
          // Extract Authorization token from headers (case-insensitive check)
          final String? authToken = response.headers.value('Authorization');
          log("the Authorization token is: $authToken");

          if (authToken != null && authToken.isNotEmpty) {
            // Save the extracted token
            await _secureStorage.saveAccessToken(authToken);
            print('verifyOTP successful: Token saved.');
            return true; // Verification successful, token saved
          } else {
            print('verifyOTP failed: Authorization header missing or empty.');
            return false; // Token missing in headers
          }
        } else {
          print('verifyOTP failed: Response body does not indicate success. Body: $responseBody');
          return false; // Body doesn't indicate success
        }
      } else {
        print('verifyOTP failed: Received non-200 status code: ${response.statusCode}');
        return false; // Status code not 200
      }
    } catch (e) {
      // Log the error for debugging
      print('Error during verifyOTP: $e');
      return false; // Indicate failure on error
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}