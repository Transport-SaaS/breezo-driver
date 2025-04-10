import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/services/shared_prefs_service.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final SharedPrefsService _prefsService;
  
  bool _isLoading = false;
  bool _isAuthenticated = false;
  UserModel? _currentUser;
  String? _error;

  AuthViewModel(this._prefsService) {
    checkAuthStatus();
  }

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;
  String? get error => _error;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    final token = _prefsService.getAuthToken();
    final userJson = _prefsService.getUserProfile();

    if (token != null && userJson != null) {
      try {
        _currentUser = UserModel.fromJson(json.decode(userJson));
        _isAuthenticated = true;
      } catch (e) {
        _error = 'Failed to parse user data';
        _isAuthenticated = false;
      }
    } else {
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Mock successful login
    if (email == 'test@example.com' && password == 'password') {
      final mockUser = UserModel(
        id: '1',
        name: 'Test User',
        email: email,
        phone: '1234567890',
      );

      await _prefsService.saveAuthToken('mock_token');
      await _prefsService.saveUserProfile(json.encode(mockUser.toJson()));
      
      _currentUser = mockUser;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _prefsService.clearAllData();
    
    _isAuthenticated = false;
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }
}