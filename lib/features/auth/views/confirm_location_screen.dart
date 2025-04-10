
import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/auth/viewmodels/location_viewmodel.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:breezodriver/widgets/location_details_modal.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

import 'dart:ui' ;
class ConfirmLocationScreen extends StatefulWidget {
  final String placeName;
  final String address;
  final bool isFromAllAddress;

  const ConfirmLocationScreen({
    Key? key,
    required this.placeName,
    required this.address,
    this.isFromAllAddress = false,
  }) : super(key: key);

  @override
  State<ConfirmLocationScreen> createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<ConfirmLocationScreen> {
  GoogleMapController? _mapController;
  BitmapDescriptor? _customMarker;

  @override
  void initState() {
    super.initState();
    _createCustomMarker();
  }

  // Create custom marker
  Future<void> _createCustomMarker() async {
    const size = 120.0;
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = AppColors.activeButton;

    // Draw outer circle
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2,
      paint..color = AppColors.activeButton.withOpacity(0.2),
    );

    // Draw inner circle
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 6,
      paint..color = AppColors.activeButton,
    );

    final img = await pictureRecorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final data = await img.toByteData(format: ImageByteFormat.png);

    if (data != null) {
      _customMarker = BitmapDescriptor.fromBytes(data.buffer.asUint8List());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Consumer<LocationViewModel>(
      builder: (context, locationViewModel, _) {
        // Get location from the view model
        final currentLocation = locationViewModel.selectedLocation;
        
        // Update map when controller is available and location changes
        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(currentLocation),
          );
        }
        
        return Scaffold(
          body: Stack(
            children: [
              // Map takes up full screen
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLocation,
                  zoom: 17
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                  // Immediately center the map when controller is available
                  controller.animateCamera(
                    CameraUpdate.newLatLng(currentLocation),
                  );
                },
                markers: {
                  Marker(
                    markerId: const MarkerId('selected_location'),
                    position: currentLocation,
                    icon: _customMarker ?? BitmapDescriptor.defaultMarker,
                  ),
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
              
              // Loading indicator if location is being fetched
              if (locationViewModel.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              
              // Current Location Button
              Positioned(
                right: 16,
                bottom: MediaQuery.of(context).size.height * 0.4, // Adjust position as needed
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    await locationViewModel.getCurrentLocation();
                    if (_mapController != null) {
                      _mapController!.animateCamera(
                        CameraUpdate.newLatLng(locationViewModel.selectedLocation),
                      );
                    }
                  },
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.black,
                  ),
                ),
              ),

              // Back button at top
              Positioned(
                top: 50,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              // Purple banner and bottom sheet
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 7, bottom: 5),
                      width: double.infinity,
                      height: screenSize.height * 0.32,
                      decoration: const BoxDecoration(
                        color: AppColors.primarycolor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        'This will be your default home address',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    // White bottom sheet - Add top position to create space
                    Positioned(
                      bottom: 0, // Add this
                      left: 0, // Add this
                      right: 0, // Add this
                      top:
                          31, // Add this to create space for the black container's text
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          16,
                          16,
                          MediaQuery.of(context).padding.bottom + 16,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Your home address',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.placeName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.address,
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(90, 30),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 3,
                                            ),
                                            backgroundColor: Colors.white,
                                            surfaceTintColor: Colors.white,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: AppColors.primarycolor,
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                30,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Change',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: CommonButton(
                                label: widget.isFromAllAddress ? 'Add Address' : 'Confirm Location',
                                isActive: true,
                                // Replace the onPressed callback in the CommonButton widget (around line 177):
                                onPressed: () async {
                                  final result = await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder:
                                        (context) => Padding(
                                          padding: EdgeInsets.only(
                                            bottom:
                                                MediaQuery.of(
                                                  context,
                                                ).viewInsets.bottom,
                                          ),
                                          child: LocationDetailsModal(
                                            placeName: widget.placeName,
                                            address: widget.address,
                                            isFromAllAddress: widget.isFromAllAddress,
                                          ),
                                        ),
                                  );

                                  if (result != null) {
                                    Navigator.pop(context, {
                                      ...result,
                                      'placeName': widget.placeName,
                                      'address': widget.address,
                                      'latLng': currentLocation,
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
