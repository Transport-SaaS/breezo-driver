import 'package:flutter/material.dart';

class WorkingSchedule {
  final bool sun;
  final bool mon;
  final bool tue;
  final bool wed;
  final bool thu;
  final bool fri;
  final bool sat;
  final String loginTime;
  final String logoutTime;

  WorkingSchedule({
    required this.sun,
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
    required this.sat,
    required this.loginTime,
    required this.logoutTime,
  });

  factory WorkingSchedule.fromJson(Map<String, dynamic> json) {
    return WorkingSchedule(
      sun: json['sun'] ?? false,
      mon: json['mon'] ?? false,
      tue: json['tue'] ?? false,
      wed: json['wed'] ?? false,
      thu: json['thu'] ?? false,
      fri: json['fri'] ?? false,
      sat: json['sat'] ?? false,
      loginTime: json['loginTime'] ?? '09:00:00',
      logoutTime: json['logoutTime'] ?? '18:00:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sun': sun,
      'mon': mon,
      'tue': tue,
      'wed': wed,
      'thu': thu,
      'fri': fri,
      'sat': sat,
      'loginTime': loginTime,
      'logoutTime': logoutTime,
    };
  }

  // Helper method to convert to TimeOfDay
  TimeOfDay getLoginTimeOfDay() {
    final parts = loginTime.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  // Helper method to convert to TimeOfDay
  TimeOfDay getLogoutTimeOfDay() {
    final parts = logoutTime.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  // Helper method to get selected days as a list
  List<bool> getSelectedDays() {
    return [mon, tue, wed, thu, fri, sat, sun];
  }
}
