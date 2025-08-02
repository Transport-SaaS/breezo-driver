import 'package:flutter/material.dart';
import '../../../core/services/shared_prefs_service.dart';

class HomeViewModel extends ChangeNotifier {

  bool _isLoading = false;
  int _selectedIndex = 0;

  bool get isLoading => _isLoading;
  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }
}