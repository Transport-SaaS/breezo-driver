import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationViewModel extends ChangeNotifier {
  LatLng _selectedLocation = LatLng(0, 0); // Default Bangalore
  bool _isLoading = false;
  String _errorMessage = '';
  
  // Added properties to store address information
  String _placeName = '';
  String _fullAddress = '';
  final String _googleApiKey = 'AIzaSyALBJu7cdnA9HCglhQLNlbxVwSEwvaZRgA'; // Replace with your actual API key
  
  LatLng get selectedLocation => _selectedLocation;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get placeName => _placeName;
  String get fullAddress => _fullAddress;
  
  /// Get the user's current location and address details
  Future<void> getCurrentLocation() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    try {
      // Check location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = 'Location services are disabled';
        _isLoading = false;
        notifyListeners();
        return;
      }
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Location permissions are denied';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        _errorMessage = 'Location permissions are permanently denied';
        _isLoading = false;
        notifyListeners();
        return;
      }
      
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      
      _selectedLocation = LatLng(position.latitude, position.longitude);
      
      // Get address details using reverse geocoding
      await _getAddressFromLatLng(_selectedLocation);
      
      _isLoading = false;
      notifyListeners();
      
    } catch (e) {
      _errorMessage = 'Error getting location: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Get address details from latitude and longitude using reverse geocoding
  Future<void> _getAddressFromLatLng(LatLng location) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json'
          '?latlng=${location.latitude},${location.longitude}'
          '&key=$_googleApiKey'
        )
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final results = data['results'];
          
          // Full address
          _fullAddress = results[0]['formatted_address'];
          
          // Extract place name (typically the first component or the locality)
          String locality = '';
          String subLocality = '';
          
          // Parse address components to find locality and sublocality
          for (var component in results[0]['address_components']) {
            final types = component['types'];
            
            if (types.contains('locality')) {
              locality = component['long_name'];
            }
            
            if (types.contains('sublocality_level_1') || types.contains('sublocality')) {
              subLocality = component['long_name'];
            }
          }
          
          // Set the place name prioritizing sublocality, then locality, then first part of address
          if (subLocality.isNotEmpty) {
            _placeName = subLocality;
          } else if (locality.isNotEmpty) {
            _placeName = locality;
          } else {
            // Fallback: use the first part of the formatted address
            final parts = _fullAddress.split(',');
            _placeName = parts.isNotEmpty ? parts[0].trim() : 'Current Location';
          }
        } else {
          _placeName = 'Current Location';
          _fullAddress = 'Your current location';
        }
      }
    } catch (e) {
      print('Error in reverse geocoding: $e');
      _placeName = 'Current Location';
      _fullAddress = 'Your current location';
    }
  }
  
  /// Update selected location manually
  void updateSelectedLocation(LatLng location) {
    _selectedLocation = location;
    notifyListeners();
  }

  Future<void> getPlaceDetails(String placeId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&key=$_googleApiKey'
          '&fields=geometry'
        )
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final geometry = data['result']['geometry']['location'];
          _selectedLocation = LatLng(
            geometry['lat'],
            geometry['lng'],
          );
        }
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error fetching place details: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
} 