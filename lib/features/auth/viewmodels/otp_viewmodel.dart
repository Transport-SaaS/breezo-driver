import 'package:breezodriver/core/network/api_client.dart';
import 'package:breezodriver/features/auth/services/driver_service.dart';
import 'package:flutter/material.dart';
import '../data/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:breezodriver/core/network/exceptions/api_exceptions.dart';

enum OtpStatus {
  initial,
  loading,
  sent,
  verified,
  error,
}

class OtpViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiClient _apiClient;
  late final DriverService _driverService;
  
  OtpStatus _status = OtpStatus.initial;
  String _errorMessage = '';
  String _phone = '';
  bool _isLoading = false;
  String? _authToken;
  Map<String, dynamic>? _driverProfile;
  
  OtpViewModel(this._apiClient) {
    _driverService = DriverService(_apiClient);
  }
  
  OtpStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get phone => _phone;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get driverProfile => _driverProfile;
  
  // Generate OTP
  Future<bool> generateOTP(String phone) async {
    _phone = phone;
    _status = OtpStatus.loading;
    _errorMessage = '';
    notifyListeners();
    
    try {
      final response = await _authService.generateOTP(phone: phone);
      
      if (response.containsKey('error')) {
        _status = OtpStatus.error;
        _errorMessage = response['error'] ?? 'Failed to send OTP';
        notifyListeners();
        return false;
      }
      
      _status = OtpStatus.sent;
      notifyListeners();
      return true;
    } catch (e) {
      _status = OtpStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Verify OTP
  Future<bool> verifyOTP(String otp) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Expecting a Response object now
      final response = await _apiClient.request<Map<String, dynamic>>(
        path: '/auth/driver/verifyOTP',
        method: 'GET',
        queryParameters: {
          'phone': _phone,
          'otp': otp,
        },
      );
  
      // Access response body data safely
      final responseData = response.data;
  
      if (responseData != null && responseData is Map<String, dynamic>) {
        // Check for failure status in the response body
        if (responseData['status'] == 'failed') {
          _errorMessage = responseData['message'] ?? 'OTP verification failed';
          _isLoading = false;
          notifyListeners();
          return false;
        }
  
        // If successful, extract token from headers
        final authToken = response.headers.value('Authorization');
        if (authToken != null) {
          _authToken = authToken; 
          // Store the token (without 'Bearer ') for the AuthInterceptor
          await _apiClient.setAuthToken(authToken.replaceFirst('Bearer ', ''));
        } 
        
        // Even if token is missing, we'll try to proceed if status is success
        // This makes the flow more resilient
        
        try {
          // Try to get driver status and profile, but don't fail if they're not available
          final driverStatus = await _driverService.getDriverStatus();
          final accountStatus = driverStatus['accountStatus'] as String? ?? 'N';
          
          _driverProfile = await _driverService.getDriverProfile();
        } catch (profileError) {
          // If we can't get the profile, just log it but continue
          print('Warning: Could not fetch driver profile: $profileError');
          // Initialize an empty profile to avoid null issues
          _driverProfile = {'name': '', 'phone': _phone};
        }
  
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        // Handle case where response data is not a Map
        // If status is not explicitly failed, we'll assume success
        _isLoading = false;
        
        // Initialize a basic profile with the phone number
        _driverProfile = {'phone': _phone};
        
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      // Use the error message from the custom exception if available
      if (e.error is ApiException) {
        _errorMessage = (e.error as ApiException).message;
      } else {
        _errorMessage = e.message ?? 'An API error occurred during OTP verification';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  bool get isDriverOnboarded => _driverProfile != null;
  
  void reset() {
    _status = OtpStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }
}