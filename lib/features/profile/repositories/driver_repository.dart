import 'package:breezodriver/features/profile/models/transporter_office_model.dart';
import 'package:dio/dio.dart';

import '../../../core/config/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../models/driver_model.dart';
import '../models/working_schedule_model.dart';

class DriverRepository {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;

  DriverRepository({
    required ApiClient apiClient,
    required SecureStorage secureStorage,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage;

  /// Get driver information
  /// Returns DriverInfo with account status
  Future<DriverInfo?> getDriverInfo() async {
    try {
      // Get the token to ensure we're authenticated
      final token = await _secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        print('DriverRepository: No auth token available');
        return null;
      }

      final response = await _apiClient.get(
        endpoint: ApiEndpoints.getDriver,
      );

      // Check for successful response
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return DriverInfo.fromJson(response.data);
      } else {
        print('DriverRepository getDriverInfo error: Status ${response.statusCode}, Body: ${response.data}');
        return null;
      }
    } catch (e) {
      print('Error during getDriverInfo: $e');
      return null;
    }
  }

  /// Get driver profile
  /// Returns DriverProfile with personal details
  Future<DriverProfile?> getDriverProfile() async {
    try {
      // Get the token to ensure we're authenticated
      final token = await _secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        print('DriverRepository: No auth token available');
        return null;
      }

      final response = await _apiClient.get(
        endpoint: ApiEndpoints.getProfile,
      );

      // Check for successful response
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return DriverProfile.fromJson(response.data);
      } else {
        print('DriverRepository getDriverProfile error: Status ${response.statusCode}, Body: ${response.data}');
        return null;
      }
    } catch (e) {
      print('Error during getDriverProfile: $e');
      return null;
    }
  }

  /// Save driver profile
  /// Returns true if profile was successfully saved
  Future<bool> saveProfile({
    required String name,
    required DateTime dateOfBirth,
    required String? email,
    required String gender,
    required int experienceYears,
    required String licenseNumber,
    required String aadharNumber,
    String? alternatePhoneNum,
    final String? contractStartDate,
    final String? contractEndDate,
    final String? profilePic,
  }) async {
    try {
      // Get the token to ensure we're authenticated
      final token = await _secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        print('DriverRepository: No auth token available');
        return false;
      }

      final Map<String, dynamic> profileData = {
        "name": name,
        "dateOfBirth": dateOfBirth.toIso8601String(),
        "gender": gender,
        "profilePic": profilePic,
        "experience": experienceYears,
        "licenseNum": licenseNumber,
        "aadharNum": aadharNumber,
        "alternatePhoneNum": alternatePhoneNum,
        "contractStartDate": contractStartDate,
        "contractEndDate": contractEndDate,
      };

      final response = await _apiClient.post(
        endpoint: ApiEndpoints.saveProfile,
        data: profileData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Check for successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Profile saved successfully');
        return true;
      } else {
        print('DriverRepository saveProfile error: Status ${response.statusCode}, Body: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error during saveProfile: $e');
      return false;
    }
  }

  /// Save driver address
  /// Returns true if address was successfully saved
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
      // Get the token to ensure we're authenticated
      final token = await _secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        print('DriverRepository: No auth token available');
        return false;
      }

      final Map<String, dynamic> addressData = {
        "active": active,
        "addressName": addressName,
        "addressText": addressText,
        "landmark": landmark,
        "lat": lat,
        "lng": lng,
        "pinCode": pinCode
      };

      final response = await _apiClient.post(
        endpoint: ApiEndpoints.saveAddress,
        data: addressData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Check for successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Address saved successfully');
        return true;
      } else {
        print('DriverRepository saveAddress error: Status ${response.statusCode}, Body: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error during saveAddress: $e');
      return false;
    }
  }

  /// Get driver company details
  /// Returns CompanyDetails with company information
  Future<TransporterOfficeModel?> getDriverTransporterOffice() async {
    try {
      // Get the token to ensure we're authenticated
      final token = await _secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        print('DriverRepository: No auth token available');
        return null;
      }

      final response = await _apiClient.get(
        endpoint: ApiEndpoints.getDriverOfficeDetails,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Check for successful response
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return TransporterOfficeModel.fromJson(response.data);
      } else {
        print('DriverRepository getDriverCompanyDetails error: Status ${response.statusCode}, Body: ${response.data}');
        return null;
      }
    } catch (e) {
      print('Error during getDriverCompanyDetails: $e');
      return null;
    }
  }

  /// Get default working schedule
  /// Returns WorkingSchedule with days and times
  Future<WorkingSchedule?> getDefaultWorkingSchedule() async {
    try {
      // Get the token to ensure we're authenticated
      final token = await _secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        print('DriverRepository: No auth token available');
        return null;
      }

      final response = await _apiClient.get(
        endpoint: ApiEndpoints.getDefaultWorkingSchedule,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Check for successful response
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return WorkingSchedule.fromJson(response.data);
      } else {
        print('DriverRepository getDefaultWorkingSchedule error: Status ${response.statusCode}, Body: ${response.data}');
        return null;
      }
    } catch (e) {
      print('Error during getDefaultWorkingSchedule: $e');
      return null;
    }
  }

  /// Save working days exception
  /// Returns true if exception was successfully saved
  Future<bool> saveWorkingDaysException({
    required String exceptionDate,
    required String adjLoginTime,
    required String adjLogoutTime,
    required bool dayOff,
    required int addressIid,
  }) async {
    print('saveWorkingDaysException in repository called with addressIid: $addressIid (${addressIid.runtimeType})');
    try {
      // Get the token to ensure we're authenticated
      final token = await _secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        print('DriverRepository: No auth token available');
        return false;
      }

      final Map<String, dynamic> exceptionData = {
        "exceptionDate": exceptionDate,
        "adjLoginTime": adjLoginTime,
        "adjLogoutTime": adjLogoutTime,
        "dayOff": dayOff,
        "addressIid": addressIid // Ensure this is an integer, not a string
      };

      print('Sending exception data: $exceptionData');

      try {
        final response = await _apiClient.post(
          endpoint: ApiEndpoints.saveWorkingDaysException,
          data: exceptionData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        // Check for successful response
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Working days exception saved successfully');
          return true;
        } else {
          print('DriverRepository saveWorkingDaysException error: Status ${response.statusCode}, Body: ${response.data}');
          return false;
        }
      } catch (e) {
        print('Inner error in saveWorkingDaysException: $e');
        return false;
      }

    } catch (e) {
      print('Outer error during saveWorkingDaysException: $e');
      return false;
    }
  }

  /// Save default working schedule
  /// Returns true if schedule was successfully saved
  Future<bool> saveDefaultWorkingSchedule({
    required bool sun,
    required bool mon,
    required bool tue,
    required bool wed,
    required bool thu,
    required bool fri,
    required bool sat,
    required String loginTime,
    required String logoutTime,
  }) async {
    try {
      // Get the token to ensure we're authenticated
      final token = await _secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        print('DriverRepository: No auth token available');
        return false;
      }

      final Map<String, dynamic> scheduleData = {
        "sun": sun,
        "mon": mon,
        "tue": tue,
        "wed": wed,
        "thu": thu,
        "fri": fri,
        "sat": sat,
        "loginTime": loginTime,
        "logoutTime": logoutTime
      };

      final response = await _apiClient.post(
        endpoint: ApiEndpoints.saveDefaultWorkingSchedule,
        data: scheduleData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Check for successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Working schedule saved successfully');
        return true;
      } else {
        print('DriverRepository saveDefaultWorkingSchedule error: Status ${response.statusCode}, Body: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error during saveDefaultWorkingSchedule: $e');
      return false;
    }
  }

  /// Get driver's planned trips
  /// Returns a list of PlannedTrip objects
  // Future<List<PlannedTrip>> getPlannedTrips() async {
  //   try {
  //     // Get the token to ensure we're authenticated
  //     final token = await _secureStorage.getAccessToken();
  //     if (token == null || token.isEmpty) {
  //       print('DriverRepository: No auth token available');
  //       return [];
  //     }
  //
  //     final response = await _apiClient.get(
  //       endpoint: ApiEndpoints.getPlannedTrips,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //         },
  //       ),
  //     );
  //
  //     print('Planned trips API response: ${response.data}');
  //
  //     // Check for successful response
  //     if (response.statusCode == 200 && response.data is List) {
  //       final List<dynamic> tripList = response.data;
  //       final trips = tripList
  //           .map((tripJson) => PlannedTrip.fromJson(tripJson))
  //           .toList();
  //       print('Parsed trips: ${trips.length}');
  //       return trips;
  //     } else {
  //       print('DriverRepository getPlannedTrips error: Status ${response.statusCode}, Body: ${response.data}');
  //       return [];
  //     }
  //   } catch (e) {
  //     print('Error during getPlannedTrips: $e');
  //     return [];
  //   }
  // }

  Future<bool> setDriverOnboarded() async {
    try {
      // Get the token to ensure we're authenticated
      final token = await _secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        print('DriverRepository: No auth token available');
        return false;
      }

      final response = await _apiClient.put(
        endpoint: ApiEndpoints.setAccountStatus,
        queryParams: {
          'status': 'onboarded',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Check for successful response
      if (response == 'success') {
        print('Driver onboarded successfully');
        return true;
      } else {
        print('DriverRepository setDriverOnboarded error: Body: $response');
        return false;
      }
    } catch (e) {
      print('Error during setDriverOnboarded: $e');
      return false;
    }
  }
}
