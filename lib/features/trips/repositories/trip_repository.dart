
import 'package:breezodriver/features/trips/models/trip_model.dart';
import 'package:dio/dio.dart';

import '../../../core/config/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../models/trip_route_model.dart';

class TripRepository {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;

  TripRepository({
    required ApiClient apiClient,
    required SecureStorage secureStorage,
  })
      : _apiClient = apiClient,
        _secureStorage = secureStorage;

  Future<List<TripModel>> getPlannedTrips() async {
    try {
      final token = await _secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        print('CustomerRepository: No auth token available');
        return [];
      }
      final response = await _apiClient.get(
        endpoint: ApiEndpoints.getPlannedTrips,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Map over the response body (response.data)
      if (response.data != null) {
        final List<dynamic> data = response.data;
        final List<TripModel> plannedTrips = data.map((trip) {
          return TripModel.fromBackendJson(trip);
        }).toList();

        return plannedTrips;
      } else {
        // Handle null response body, perhaps return empty list or throw error
        print('TripRepository getTripSchedules error: Response body is null');
        return [];
      }
    } catch (e) {
      print('Error getting planned trips: $e');
      return [];
    }
  }

  Future<List<TripModel>> getPastTrips() async {
    try {
      final token = await _secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        print('TripRepository: No auth token available');
        return [];
      }
      final response = await _apiClient.get(
        endpoint: ApiEndpoints.getDriverPastOneWeekTrips,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Map over the response body (response.data)
      if (response.data != null) {
        final List<dynamic> data = response.data;
        final List<TripModel> pastTrips = data.map((trip) {
          return TripModel.fromBackendJson(trip);
        }).toList();

        return pastTrips;
      } else {
        // Handle null response body, perhaps return empty list or throw error
        print('TripRepository getPastTrips error: Response body is null');
        return [];
      }
    } catch (e) {
      print('Error getting past trips: $e');
      return [];
    }
  }
  Future<TripRouteModel> getTripRoute(int tripId, bool isPastTrip) async {
    try {
      final token = await _secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        print('TripRepository: No auth token available');
        return TripRouteModel.empty();
      }
      final response = await _apiClient.get(
        endpoint: ApiEndpoints.getTripDetails,
        queryParams: {
          'trip_iid': tripId,
          'is_past_trip': isPastTrip
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Map over the response body (response.data)
      if (response.data != null) {
        TripRouteModel data = TripRouteModel.fromJson(response.data);
        print('TripRepository getTripRoute: $data');
        return data;
      } else {
        // Handle null response body, perhaps return empty list or throw error
        print('TripRepository getTripRoute error: Response body is null');
        return TripRouteModel.empty();
      }
    } catch (e) {
      print('Error getting trip route: $e');
      return TripRouteModel.empty();
    }
  }
}