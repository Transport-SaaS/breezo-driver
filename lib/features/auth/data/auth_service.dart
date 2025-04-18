import 'dart:convert';

import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/auth_response.dart';
import '../models/user.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<AuthResponse> login({
    required String phone,
    required String password,
  }) async {
    final response = await _apiClient.request<Map<String, dynamic>>(
      path: '/api/v1/auth/login',
      method: 'POST',
      data: {
        'phone': phone,
        'password': password,
      },
    );

    final authResponse = AuthResponse.fromJson(response.data!);
    await _apiClient.setAuthToken(authResponse.token);
    return authResponse;
  }

  Future<AuthResponse> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.request<Map<String, dynamic>>(
      path: '/api/v1/auth/register',
      method: 'POST',
      data: {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
      },
    );

    final authResponse = AuthResponse.fromJson(response.data!);
    await _apiClient.setAuthToken(authResponse.token);
    return authResponse;
  }

  Future<User> getCurrentUser() async {
    final response = await _apiClient.request<Map<String, dynamic>>(
      path: '/api/v1/auth/me',
      method: 'GET',
    );

    return User.fromJson(response.data!);
  }

  Future<void> logout() async {
    await _apiClient.request(
      path: '/api/v1/auth/logout',
      method: 'POST',
    );
    await _apiClient.clearAuthToken();
  }

  Future<void> forgotPassword(String phone) async {
    await _apiClient.request(
      path: '/api/v1/auth/forgot-password',
      method: 'POST',
      data: {'phone': phone},
    );
  }

  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    await _apiClient.request(
      path: '/api/v1/auth/reset-password',
      method: 'POST',
      data: {
        'phone': phone,
        'otp': otp,
        'password': newPassword,
      },
    );
  }

  // New OTP methods
  Future<Map<String, dynamic>> generateOTP({required String phone}) async {
    try {
      final response = await _apiClient.request(
        path: '/auth/driver/generateOTP',
        method: 'GET',
        queryParameters: {'phone': phone},
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

  Future<Map<String, dynamic>> verifyOTP({
    required String phone, 
    required String otp
  }) async {
    try {
      final response = await _apiClient.request(
        path: '/auth/driver/verifyOTP',
        method: 'GET',
        queryParameters: {
          'phone': phone,
          'otp': otp,
        },
      );
      
      // Access data from the Response object
      final responseData = response.data;

      // Handle different response types based on responseData
      if (responseData is Map<String, dynamic>) {
        return responseData;
      } else if (responseData is String) {
        // Try to parse string as JSON
        try {
          final jsonResponse = json.decode(responseData);
          if (jsonResponse is Map<String, dynamic>) {
            return jsonResponse;
          }
        } catch (_) {
          // Not valid JSON, continue with default handling
        }
        
        // If not valid JSON, check for success/failure keywords in responseData
        if (responseData.toLowerCase().contains('success')) {
          return {'status': 'success'};
        } else if (responseData.toLowerCase().contains('fail')) {
          return {'status': 'failed', 'message': responseData};
        }
        
        // Default string response
        return {'data': responseData};
      } else if (responseData == null) {
        return {'status': 'success'};
      } else if (responseData is bool) {
        return {'status': responseData ? 'success' : 'failed'};
      } else if (responseData is int) {
        // Assuming non-zero is success
        return {'status': responseData != 0 ? 'success' : 'failed'};
      } else {
        // For any other type, convert to string
        return {'data': responseData.toString()};
      }
    } catch (e) {
      return {'status': 'failed', 'message': e.toString()};
    }
  }
}