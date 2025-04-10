import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BusinessViewModel extends ChangeNotifier {
  DateTime? _contractStart;
  DateTime? _contractEnd;
  int _shiftStartHour = 7;
  int _shiftStartMinute = 30;
  bool _shiftStartIsAm = true;
  int _shiftEndHour = 2;
  int _shiftEndMinute = 30;
  bool _shiftEndIsAm = false;
  List<bool> _workingDays = List.generate(7, (index) => true);

  // Getters
  DateTime? get contractStart => _contractStart;
  DateTime? get contractEnd => _contractEnd;
  int get shiftStartHour => _shiftStartHour;
  int get shiftStartMinute => _shiftStartMinute;
  bool get shiftStartIsAm => _shiftStartIsAm;
  int get shiftEndHour => _shiftEndHour;
  int get shiftEndMinute => _shiftEndMinute;
  bool get shiftEndIsAm => _shiftEndIsAm;
  List<bool> get workingDays => _workingDays;

  // Static lists for dropdowns
  static final List<int> hours = List.generate(12, (index) => index + 1);
  static final List<int> minutes = [0, 30];
  static final List<bool> amPm = [true, false]; // true for AM, false for PM

  // TimeOfDay getters
  TimeOfDay get shiftStart => TimeOfDay(
    hour: _shiftStartIsAm ? _shiftStartHour : (_shiftStartHour == 12 ? 12 : _shiftStartHour + 12),
    minute: _shiftStartMinute,
  );

  TimeOfDay get shiftEnd => TimeOfDay(
    hour: _shiftEndIsAm ? _shiftEndHour : (_shiftEndHour == 12 ? 12 : _shiftEndHour + 12),
    minute: _shiftEndMinute,
  );

  // Calculate working hours
  String getWorkingHours() {
    if (_shiftStartHour == 0 && _shiftEndHour == 0) return '0 hours';

    int startHour = _shiftStartHour;
    if (!_shiftStartIsAm && startHour != 12) startHour += 12;
    if (_shiftStartIsAm && startHour == 12) startHour = 0;

    int endHour = _shiftEndHour;
    if (!_shiftEndIsAm && endHour != 12) endHour += 12;
    if (_shiftEndIsAm && endHour == 12) endHour = 0;

    int startMinutes = startHour * 60 + _shiftStartMinute;
    int endMinutes = endHour * 60 + _shiftEndMinute;

    if (endMinutes < startMinutes) {
      endMinutes += 24 * 60; // Add 24 hours
    }

    int diffMinutes = endMinutes - startMinutes;
    return '${(diffMinutes / 60).floor()} hours ${diffMinutes % 60 > 0 ? '30 min' : ''}';
  }

  // Calculate contract duration
  String getContractDuration() {
    if (_contractStart == null || _contractEnd == null) return '';
    
    final difference = _contractEnd!.difference(_contractStart!);
    final years = (difference.inDays / 365).floor();
    final months = ((difference.inDays % 365) / 30).floor();
    
    if (years > 0 && months > 0) {
      return '$years years $months months';
    } else if (years > 0) {
      return '$years years';
    } else if (months > 0) {
      return '$months months';
    } else {
      return '${difference.inDays} days';
    }
  }

  // Setters
  void setShiftStart({required int hour, required int minute, required bool isAm}) {
    _shiftStartHour = hour;
    _shiftStartMinute = minute;
    _shiftStartIsAm = isAm;
    notifyListeners();
  }

  void setShiftEnd({required int hour, required int minute, required bool isAm}) {
    _shiftEndHour = hour;
    _shiftEndMinute = minute;
    _shiftEndIsAm = isAm;
    notifyListeners();
  }

  void setContractStart(DateTime date) {
    _contractStart = date;
    notifyListeners();
  }

  void setContractEnd(DateTime date) {
    _contractEnd = date;
    notifyListeners();
  }

  void toggleWorkingDay(int index) {
    _workingDays[index] = !_workingDays[index];
    notifyListeners();
  }
}