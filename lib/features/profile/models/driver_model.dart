import 'package:flutter/foundation.dart';

class DriverInfo {
  final String mobileNum;
  final String accountStatus;
  
  DriverInfo({
    required this.mobileNum,
    required this.accountStatus,
  });
  
  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      mobileNum: json['mobileNum'] ?? '',
      accountStatus: json['accountStatus'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'mobileNum': mobileNum,
      'accountStatus': accountStatus,
    };
  }
  
  // Check if account is open/active
  bool get isAccountOpen => accountStatus == 'O';
}

class DriverProfile {
  final int id;
  final String name;
  final String? email;
  final String? gender;
  final int experienceYears;
  final String licenseNumber;
  final String aadharNumber;
  final DateTime contractStartDate;
  final int contractDurationMonths;
  final String? profilePic;
  
  DriverProfile({
    this.id = 0,
    required this.name,
    this.email,
    this.gender,
    this.experienceYears = 0,
    this.licenseNumber = '',
    this.aadharNumber = '',
    required this.contractStartDate ,
    this.contractDurationMonths = 0,
    this.profilePic,
  });
  
  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      id: json['driverIid'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'],
      gender: json['gender'],
      experienceYears: json['experience'] ?? 0,
      licenseNumber: json['licenseNum'] ?? '',
      aadharNumber: json['aadharNum'] ?? '',
      contractStartDate: DateTime.parse(json['contractStartDate'] ?? DateTime.now().toIso8601String()),
      contractDurationMonths: json['contractTenure'] ?? 0,
      profilePic: json['profilePic'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'customerIid': id,
      'name': name,
      'email': email,
      'gender': gender,
      'experience': experienceYears,
      'licenseNum': licenseNumber,
      'aadharNum': aadharNumber,
      'contractStartDate': contractStartDate.toIso8601String(),
      'contractTenure': contractDurationMonths,
      'profilePic': profilePic,
    };
  }
}