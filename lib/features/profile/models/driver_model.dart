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
  final String? name;
  final DateTime? dateOfBirth;
  final String? email;
  final String? gender;
  final int? experienceYears;
  final String? licenseNumber;
  final String? aadharNumber;
  final String? alternatePhoneNum;
  late DateTime? contractStartDate;
  late DateTime? contractEndDate;
  final String? currentAddress;
  final String? permanentAddress;
  final String? profilePic;
  
  DriverProfile({
    this.id = 0,
    required this.name,
    required this.dateOfBirth,
    this.email,
    this.gender='m',
    this.experienceYears = 0,
    this.licenseNumber = '',
    this.aadharNumber = '',
    this.alternatePhoneNum,
    this.contractStartDate,
    this.contractEndDate,
    this.currentAddress = '',
    this.permanentAddress = '',
    this.profilePic,
  });
  
  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      id: json['driverIid'] ?? 0,
      name: json['name'] ?? '',
      dateOfBirth: DateTime.parse(json['dateOfBirth'] ?? DateTime.timestamp().toIso8601String()),
      email: json['email'],
      gender: json['gender'],
      experienceYears: json['experience'] ?? 0,
      licenseNumber: json['licenseNum'] ?? '',
      aadharNumber: json['aadharNum'] ?? '',
      alternatePhoneNum: json['alternatePhoneNum'],
      contractStartDate: DateTime.parse(json['contractStartDate']),
      contractEndDate: DateTime.parse(json['contractEndDate']),
      currentAddress: json['currentAddress'] ?? '',
      permanentAddress: json['permanentAddress'] ?? '',
      profilePic: json['profilePic'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'customerIid': id,
      'name': name,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'email': email,
      'gender': gender,
      'experience': experienceYears,
      'licenseNum': licenseNumber,
      'aadharNum': aadharNumber,
      'alternatePhoneNum': alternatePhoneNum,
      'contractStartDate': contractStartDate?.toIso8601String(),
      'contractEndDate': contractEndDate?.toIso8601String(),
      'currentAddress': currentAddress,
      'permanentAddress': permanentAddress,
      'profilePic': profilePic,
    };
  }
}