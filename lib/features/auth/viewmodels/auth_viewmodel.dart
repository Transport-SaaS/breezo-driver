import 'dart:convert';
import 'package:breezodriver/features/auth/data/auth_repository.dart';
import 'package:flutter/material.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/services/shared_prefs_service.dart';
import '../models/user_model.dart';

enum AuthStatus {
  initial,
  loading,
  otpSent,
  authenticated,
  error,
}
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = serviceLocator<AuthRepository>();

  AuthStatus _status = AuthStatus.initial;
  String _phoneNumber = '';
  String _errorMessage = '';
  Map<String, dynamic>? _userData;

  // Getters
  AuthStatus get status => _status;
  String get phoneNumber => _phoneNumber;
  String get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _status == AuthStatus.loading;

  // Set phone number
  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    try {
      final isAuth = await _authRepository.isAuthenticated();

      if (isAuth) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.initial;
      }

      notifyListeners();
      return isAuth;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    print('!!!!Login called with email: $email and password: $password !!!!');
    return true;
    // _isLoading = true;
    // _error = null;
    // notifyListeners();
    //
    // // Simulate API call
    // await Future.delayed(const Duration(seconds: 2));
    //
    // // Mock successful login
    // if (email == 'test@example.com' && password == 'password') {
    //   final mockUser = UserModel(
    //     id: '1',
    //     name: 'Test User',
    //     email: email,
    //     phone: '1234567890',
    //   );
    //
    //   await _prefsService.saveAuthToken('mock_token');
    //   await _prefsService.saveUserProfile(json.encode(mockUser.toJson()));
    //
    //   _currentUser = mockUser;
    //   _isAuthenticated = true;
    //   _isLoading = false;
    //   notifyListeners();
    //   return true;
    // } else {
    //   _error = 'Invalid email or password';
    //   _isLoading = false;
    //   notifyListeners();
    //   return false;
    // }
  }

  Future<void> logout() async {
    print('!!!!Logout called!!!!');
    // _isLoading = true;
    // notifyListeners();
    //
    // await _prefsService.clearAllData();
    //
    // _isAuthenticated = false;
    // _currentUser = null;
    // _isLoading = false;
    // notifyListeners();
  }

  Future<bool> generateOTP(String phone) async {
    _phoneNumber = phone;
    _status = AuthStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _authRepository.generateOTP(phone: phone);

      if (response.containsKey('error')) {
        _status = AuthStatus.error;
        _errorMessage = response['error'] ?? 'Failed to send OTP';
        notifyListeners();
        return false;
      }

      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Verify OTP
  Future<bool> verifyOTP(String otp) async {
    if (otp.isEmpty || otp.length < 4) {
      _errorMessage = 'Please enter a valid OTP';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }

    try {
      _status = AuthStatus.loading;
      notifyListeners();

      final result = await _authRepository.verifyOTP(_phoneNumber, otp);

      // The result is now a boolean indicating success (true) or failure (false)
      if (result) {
        _status = AuthStatus.authenticated;
        _errorMessage = '';
        // Note: We no longer receive user data directly from verifyOTP.
        // If user data is needed immediately, a separate fetch call might be required here.
        _userData = null; // Clear any previous user data if needed
      } else {
        _status = AuthStatus.error;
        // Set a generic error message as verifyOTP doesn't provide details anymore
        _errorMessage = 'OTP verification failed';
      }

      notifyListeners();
      // Return the boolean result directly
      return result;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkAuthentication() async {
    try {
      final isAuth = await _authRepository.isAuthenticated();

      if (isAuth) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.initial;
      }

      notifyListeners();
      return isAuth;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

}