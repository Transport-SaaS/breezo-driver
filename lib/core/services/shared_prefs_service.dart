import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  final SharedPreferences _prefs;

  SharedPrefsService(this._prefs);

  // User related methods
  Future<bool> saveAuthToken(String token) async {
    return await _prefs.setString('auth_token', token);
  }

  String? getAuthToken() {
    return _prefs.getString('auth_token');
  }

  Future<bool> clearAuthToken() async {
    return await _prefs.remove('auth_token');
  }

  // User profile data
  Future<bool> saveUserProfile(String userData) async {
    return await _prefs.setString('user_profile', userData);
  }

  String? getUserProfile() {
    return _prefs.getString('user_profile');
  }

  // App settings
  Future<bool> saveDarkModePreference(bool isDarkMode) async {
    return await _prefs.setBool('dark_mode', isDarkMode);
  }

  bool getDarkModePreference() {
    return _prefs.getBool('dark_mode') ?? false;
  }

  // Clear all data (logout)
  Future<bool> clearAllData() async {
    return await _prefs.clear();
  }
}