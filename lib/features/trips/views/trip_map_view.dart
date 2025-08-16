import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/trips/models/trip_model.dart';
import 'package:breezodriver/features/trips/viewmodels/trip_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class TripMapView extends StatefulWidget {
  final TripModel trip;
  final TripDetailsViewModel viewModel;

  const TripMapView({
    Key? key,
    required this.trip,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<TripMapView> createState() => _TripMapViewState();
}

class _TripMapViewState extends State<TripMapView> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  
  // Sample coordinates (Bangalore area) - would be replaced with real data
  LatLng _startLocation = LatLng(17.9716, 77.5946);
  LatLng _endLocation = LatLng(17.0499, 77.5700);
  
  // Current taxi location - would be updated in real-time
  LatLng _taxiLocation = LatLng(17.5716, 78.5946);
  
  // Passenger locations - simulated
  final List<LatLng> _passengerLocations = [];
  BitmapDescriptor? _taxiIcon;
  BitmapDescriptor? _passengerIcon;
  BitmapDescriptor? _destinationIcon;
  
  bool _mapLoaded = false;

  @override
  void initState() {
    super.initState();
    // Initialize start and end locations
    _startLocation = LatLng(widget.trip.startLocation[1], widget.trip.startLocation[0]);
    _endLocation = LatLng(widget.trip.endLocation[1], widget.trip.endLocation[0]);
    _setupMarkerIcons();
    _generatePassengerLocations();
    _setupPolylines();

    //update taxi location every 5 seconds
    Timer.periodic(const Duration(seconds: 5), (timer) {
      getAndUpdateTaxiLocation();
    });
  }

  void getAndUpdateTaxiLocation() {
    // Simulate getting the current taxi location from a service
    // In a real app, this would be replaced with actual location updates
    LatLng newLocation = LatLng(
      _taxiLocation.latitude + 0.0001, // Simulate movement
      _taxiLocation.longitude + 0.0001,
    );

    updateTaxiLocation(newLocation);
  }

  void updateTaxiLocation(LatLng newLocation) {
    setState(() {
      _taxiLocation = newLocation;
      _markers.removeWhere((m) => m.markerId.value == 'taxi');
      _markers.add(
        Marker(
          markerId: const MarkerId('taxi'),
          position: _taxiLocation,
          icon: _taxiIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    });
  }
  
  Future<void> _setupMarkerIcons() async {
    try {
      final Uint8List taxiIconData = await _getBytesFromAsset('assets/images/taxi.png', 100);
      _taxiIcon = BitmapDescriptor.fromBytes(taxiIconData);
      
      _passengerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      _destinationIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
      
      setState(() {});
    } catch (e) {
      print('Error loading marker icons: $e');
      _taxiIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      _passengerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      _destinationIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }
  
  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _generatePassengerLocations() {
    // Generate intermediate points between start and end locations
    _passengerLocations.clear();
    for (int i = 1; i <= widget.trip.passengerList.length; i++) {
      _passengerLocations.add(
        LatLng(
          widget.trip.passengerList[i - 1].location[1],
          widget.trip.passengerList[i - 1].location[0]
        ),
      );
    }
  }
  
  void _setupPolylines() {
    // Create a list of all points in the route
    List<LatLng> routePoints = [_startLocation];
    routePoints.addAll(_passengerLocations);
    routePoints.add(_endLocation);
    
    // Create polyline segments with different colors
    for (int i = 0; i < routePoints.length - 1; i++) {
      // Use different colors for different segments
      Color polylineColor;
      if (i == 0) {
        // First segment (completed) - green
        polylineColor = AppColors.primarycolor;
      } else if (i == 1) {
        // Current segment (active) - teal
        polylineColor = Colors.teal;
      } else {
        // Future segments - grey
        polylineColor = Colors.grey.shade600;
      }
      
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route_segment_$i'),
          points: [routePoints[i], routePoints[i + 1]],
          color: polylineColor,
          width: 4,
        ),
      );
    }
  }

  void _setupMarkers() {
    if (_taxiIcon == null || _passengerIcon == null || _destinationIcon == null) return;
    
    _markers.clear();
    
    // Add taxi marker
    _markers.add(
      Marker(
        markerId: const MarkerId('taxi'),
        position: _taxiLocation,
        icon: _taxiIcon!,
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    );
    
    // Add passenger markers with info windows
    for (int i = 0; i < _passengerLocations.length; i++) {
      final passenger = widget.trip.passengerList[i];
      final passengerLocation = _passengerLocations[i];
      
      // Calculate ETA (just for demo)
      final eta = i == 0 ? '+7 min' : '+${(i + 2) * 5} min';
      
      _markers.add(
        Marker(
          markerId: MarkerId('passenger_$i'),
          position: passengerLocation,
          icon: _passengerIcon!,
          infoWindow: InfoWindow(
            title: passenger.name,
            snippet: 'Drop ${i + 1} $eta',
          ),
        ),
      );
    }
    
    // Add destination marker
    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: _endLocation,
        icon: _destinationIcon!,
        infoWindow: const InfoWindow(title: 'Destination'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _setupMarkers();
    
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _startLocation,
            zoom: 12,
          ),
          markers: _markers,
          polylines: _polylines,
          myLocationEnabled: false,
          compassEnabled: true,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            setState(() {
              _mapLoaded = true;
            });
            // Fit the map to show all markers
            _fitAllMarkers();
          },
        ),
        
        // ETA, driver details, current passenger chip at the top
        if (_mapLoaded)
          Positioned(
            top: 10,
            left: 16,
            right: 16,
            child: Column(
              children: [
                for (int i = 0; i < _passengerLocations.length; i++)
                  if (i == 0) // Just show the first passenger for now
                    _buildPassengerChip(
                      widget.trip.passengerList[i], 
                      i + 1, 
                      '+7 min',
                    ),
              ],
            ),
          ),
      ],
    );
  }
  
  Widget _buildPassengerChip(Passenger passenger, int dropNumber, String eta) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: _getAvatarColor(passenger.initials),
            child: Text(
              passenger.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  passenger.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Drop $dropNumber',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              eta,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getAvatarColor(String initials) {
    // Map initials to specific colors to match the screenshot
    const Map<String, Color> colorMap = {
      'BK': Color(0xFF6B7280), // Grey
      'BM': Color(0xFFEC4899), // Pink
      'AG': Color(0xFF8B5CF6), // Purple
      'VB': Color(0xFFEF4444), // Red
      'KE': Color(0xFF10B981), // Green
      'MV': Color(0xFF3B82F6), // Blue
    };
    
    return colorMap[initials] ?? Colors.blue;
  }
  
  Future<void> _fitAllMarkers() async {
    if (_markers.isEmpty) return;
    
    final GoogleMapController controller = await _controller.future;
    
    // Get bounds for all markers
    double minLat = 90;
    double maxLat = -90;
    double minLng = 180;
    double maxLng = -180;
    
    for (final marker in _markers) {
      final pos = marker.position;
      if (pos.latitude < minLat) minLat = pos.latitude;
      if (pos.latitude > maxLat) maxLat = pos.latitude;
      if (pos.longitude < minLng) minLng = pos.longitude;
      if (pos.longitude > maxLng) maxLng = pos.longitude;
    }
    
    // Add some padding
    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat - 0.01, minLng - 0.01),
      northeast: LatLng(maxLat + 0.01, maxLng + 0.01),
    );
    
    // Animate camera to fit bounds
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }
} 