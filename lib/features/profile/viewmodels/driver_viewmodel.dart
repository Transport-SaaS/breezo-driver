import 'package:breezodriver/core/services/service_locator.dart';
import 'package:breezodriver/features/profile/models/driver_model.dart';
import 'package:breezodriver/features/profile/models/transporter_office_model.dart';
import 'package:breezodriver/features/profile/repositories/driver_repository.dart';
import 'package:flutter/cupertino.dart';

import '../models/working_schedule_model.dart';

enum DriverDataStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

class DriverViewModel extends ChangeNotifier {
  final DriverRepository _driverRepository = serviceLocator<DriverRepository>();

  DriverDataStatus _status = DriverDataStatus.initial;
  DriverInfo? _driverInfo;
  DriverProfile? _driverProfile;
  TransporterOfficeModel? _transporterOfficeModel;
  WorkingSchedule? _workingSchedule;
  // List<Address> _addresses = [];
  String _errorMessage = '';

  // Getters
  DriverDataStatus get status => _status;
  DriverInfo? get driverInfo => _driverInfo;
  DriverProfile? get driverProfile => _driverProfile;
  TransporterOfficeModel? get transporterOfficeModel => _transporterOfficeModel;
  // WorkingSchedule? get workingSchedule => _workingSchedule;
  // List<Address> get addresses => _addresses;
  String get errorMessage => _errorMessage;
  bool get isLoading => _status == DriverDataStatus.loading;

  // Get active addresses only
  // List<Address> get activeAddresses => _addresses.where((address) => address.active).toList();

  // Check if driver has an open account
  bool get hasOpenAccount => _driverInfo?.isAccountOpen ?? false;

  // Load driver data (info and profile if account is open)
  Future<bool> loadDriverData() async {
    try {
      _status = DriverDataStatus.loading;
      notifyListeners();

      // First, get driver info to check account status
      final driverInfo = await _driverRepository.getDriverInfo();

      if (driverInfo == null) {
        _status = DriverDataStatus.error;
        _errorMessage = 'Failed to load driver information';
        notifyListeners();
        return false;
      }

      _driverInfo = driverInfo;

      // If account is open, get profile data
      if (driverInfo.isAccountOpen) {
        final driverProfile = await _driverRepository.getDriverProfile();

        if (driverProfile != null) {
          _driverProfile = driverProfile;
          _status = DriverDataStatus.loaded;
        } else {
          // Profile data couldn't be loaded, but we have driver info
          _status = DriverDataStatus.empty;
        }
      } else {
        // Account is not open, so we don't need profile data
        _status = DriverDataStatus.empty;
      }

      _errorMessage = '';
      notifyListeners();
      return true;

    } catch (e) {
      _status = DriverDataStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Clear driver data
  void clearDriverData() {
    _driverInfo = null;
    _driverProfile = null;
    _status = DriverDataStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }

  // Load company details
  Future<bool> loadTransporterOfficeDetails() async {
    try {
      _status = DriverDataStatus.loading;
      notifyListeners();

      final transporterOffice = await _driverRepository.getDriverTransporterOffice();

      if (transporterOffice != null) {
        _transporterOfficeModel = transporterOffice;
        _status = DriverDataStatus.loaded;
        _errorMessage = '';
      } else {
        _status = DriverDataStatus.error;
        _errorMessage = 'Failed to load company details';
      }

      notifyListeners();
      return transporterOffice != null;
    } catch (e) {
      _status = DriverDataStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Load working schedule
  Future<bool> loadWorkingSchedule() async {
    try {
      _status = DriverDataStatus.loading;
      notifyListeners();

      final workingSchedule = await _driverRepository.getDefaultWorkingSchedule();

      if (workingSchedule != null) {
        _workingSchedule = workingSchedule;
        _status = DriverDataStatus.loaded;
        _errorMessage = '';
      } else {
        _status = DriverDataStatus.error;
        _errorMessage = 'Failed to load working schedule';
      }

      notifyListeners();
      return workingSchedule != null;
    } catch (e) {
      _status = DriverDataStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Save driver profile
  Future<bool> saveProfile({
    required String name,
    required DateTime dateOfBirth,
    required String email,
    required String gender,
    required int experienceYears,
    required String licenseNumber,
    required String aadharNumber,
    required String? alternatePhoneNum,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    final String? profilePic,
  }) async {
    try {
      _status = DriverDataStatus.loading;
      notifyListeners();

      final result = await _driverRepository.saveProfile(
        name: name,
        dateOfBirth: dateOfBirth,
        email: email,
        gender: gender,
        experienceYears: experienceYears,
        licenseNumber: licenseNumber,
        aadharNumber: aadharNumber,
        alternatePhoneNum: alternatePhoneNum,
        contractStartDate: contractStartDate,
        contractEndDate: contractEndDate,
        profilePic: profilePic,
      );

      if (result) {
        // Update the local profile data
        _driverProfile = DriverProfile(
          name: name,
          dateOfBirth: dateOfBirth,
          email: email,
          gender: gender,
          experienceYears: experienceYears,
          licenseNumber: licenseNumber,
          aadharNumber: aadharNumber,
          alternatePhoneNum: alternatePhoneNum,
          contractStartDate: contractStartDate,
          contractEndDate: contractEndDate,
          profilePic: profilePic,
        );

        _errorMessage = '';
        _status = DriverDataStatus.loaded;
      } else {
        _errorMessage = 'Failed to save profile';
        _status = DriverDataStatus.error;
      }

      notifyListeners();
      return result;
    } catch (e) {
      _status = DriverDataStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> saveContractDetails({
    DateTime? contractStartDate,
    DateTime? contractEndDate,
  }) async {
    try {
      _status = DriverDataStatus.loading;
      notifyListeners();

      final result = await _driverRepository.saveProfile(
        name: driverProfile!.name,
        dateOfBirth: driverProfile!.dateOfBirth,
        email: driverProfile!.email,
        gender: driverProfile!.gender,
        experienceYears: driverProfile!.experienceYears,
        licenseNumber: driverProfile!.licenseNumber,
        aadharNumber: driverProfile!.aadharNumber,
        alternatePhoneNum: driverProfile!.alternatePhoneNum,
        contractStartDate: contractStartDate,
        contractEndDate: contractEndDate,
        profilePic: driverProfile!.profilePic,
      );

      if (result) {
        // Update the local profile data
        _driverProfile?.contractStartDate = contractStartDate;
        _driverProfile?.contractEndDate = contractEndDate;

        _errorMessage = '';
        _status = DriverDataStatus.loaded;
      } else {
        _errorMessage = 'Failed to save contract details';
        _status = DriverDataStatus.error;
      }

      notifyListeners();
      return result;
    } catch (e) {
      _status = DriverDataStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> setDriverOnboarded() async {
    try {
      _status = DriverDataStatus.loading;
      notifyListeners();

      final result = await _driverRepository.setDriverOnboarded();

      if (result) {
        _errorMessage = '';
        _status = DriverDataStatus.loaded;
      } else {
        _errorMessage = 'Failed to set driver onboarded';
        _status = DriverDataStatus.error;
      }

      notifyListeners();
      return result;
    } catch (e) {
      _status = DriverDataStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> saveAddress({
    required String addressName,
    required String addressText,
    required double lat,
    required double lng,
    String? landmark,
    required String pinCode,
    bool active = false,
  }) async {
    try {
      _status = DriverDataStatus.loading;
      notifyListeners();

      final result = await _driverRepository.saveAddress(
        addressName: addressName,
        addressText: addressText,
        lat: lat,
        lng: lng,
        landmark: landmark,
        pinCode: pinCode,
        active: active,
      );

      if (result) {
        _errorMessage = '';
        _status = DriverDataStatus.loaded;
      } else {
        _errorMessage = 'Failed to save address';
        _status = DriverDataStatus.error;
      }

      notifyListeners();
      return result;
    } catch (e) {
      _status = DriverDataStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

}
