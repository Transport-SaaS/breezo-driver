import 'dart:async';
import 'dart:convert';

import 'package:breezodriver/core/utils%20copy/size_config.dart';
import 'package:breezodriver/core/utils/app_assets.dart';
import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/profile/views/profile_screen.dart';
import 'package:breezodriver/widgets/todays_trip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/config/api_endpoints.dart';
import '../../profile/viewmodels/driver_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  void startLocationUpdates(String driverId) {
    // This method should start location updates for the driver
    // Implementation depends on your location service setup
    // For example, you might use a background service or a periodic timer
    print('Starting location updates for driver');
    print('creating Pulsar WebSocket connection...');
    final channel = WebSocketChannel.connect(
      Uri.parse('${ApiEndpoints.baseWsURL}/ws/v2/consumer/persistent/public/default/driver-location-updates-$driverId/trip-events-subscription?subscriptionType=Shared'),
    );

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
      final currentLocation = {
        'lat': position.latitude,
        'lng': position.longitude,
        'driverIid': driverId,
      };

      // Send the location update to the WebSocket channel
      channel.sink.add(json.encode(currentLocation));
    });
  }

  @override
  Widget build(BuildContext context) {
    String address = 'Building No. 134, Mahalaxmi Nagar, Nagasandra, Bangalore';
    String addressName = 'Home';
    String driverName = 'Unknown';
    String driverRating = '0.0';
    String vehicleModel = 'Unknown';
    String vehicleColor = 'Unknown';
    String vehicleNumber = 'Unknown';

    final driverViewModel = Provider.of<DriverViewModel>(context, listen: false);
    startLocationUpdates(driverViewModel.driverProfile!.id.toString());
    if (driverViewModel.defaultAddress != null) {
      address = driverViewModel.defaultAddress!.addressText;
      addressName = driverViewModel.defaultAddress!.addressName;
      driverName = driverViewModel.driverProfile?.name ?? 'Unknown';
      vehicleNumber = driverViewModel.vehicle?.registrationNo ?? 'Unknown';
      vehicleColor = driverViewModel.vehicle?.colour ?? 'Unknown';
      vehicleModel = driverViewModel.vehicle?.brandName ?? 'Unknown';
    }
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 26.0),
          child: SvgPicture.asset(AppAssets.location, color: Colors.white),
        ),
        leadingWidth:
            MediaQuery.of(context).size.width *
            0.13, // ~50px on standard screen

        actions: [
          Icon(
            Icons.notifications,
            color: Colors.white,
            size: MediaQuery.of(context).size.width * 0.06, // ~24px
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02), // ~8px
          GestureDetector
          (
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            child: Icon(
              Icons.menu,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.06,
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02), // ~8px
        ],
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  addressName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        MediaQuery.of(context).size.width * 0.045, // ~18px
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ), // ~8px
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        MediaQuery.of(context).size.width * 0.02, // ~8px
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'DEFAULT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          MediaQuery.of(context).size.width * 0.03, // ~12px
                    ),
                  ),
                ),
              ],
            ),
            Text(
              address.length > 40 ? '${address.substring(0, 40)}...' : address,
              style: TextStyle(
                color: Colors.white70,
                fontSize: MediaQuery.of(context).size.width * 0.03, // ~12px
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primarycolor,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      backgroundColor: AppColors.primarycolor,
      body: SafeArea(
        // Rest of your existing body code remains unchanged
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 0.04, // ~16px
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height *
                                  0.01, // ~16px
                            ),

                            // Stats Card
                            Container(
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // Main content
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Profile photo and rating
                                            Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: 28,
                                                  backgroundImage:
                                                      const AssetImage(
                                                        'assets/images/driver.png',

                                                      ),
                                                ),

                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xffFFEAAC),
                                                    border: Border.all(
                                                      color: Colors.amber,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15
                                                        )
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 2),
                                                      Text(
                                                        driverRating,
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(width: 10), // ~4px

                                            // Driver info and schedule
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Driver name and online status
                                                  Row(
                                                    children: [
                                                      Text(
                                                        driverName,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 2,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.green
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                4,
                                                              ),
                                                        ),
                                                        child: const Text(
                                                          'Online',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),

                                                  // Car model
                                                  Text(
                                                    '$vehicleColor $vehicleModel',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),

                                                 
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                         // Schedule
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Mon-Fri',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(
                                                '07:30 pm - 02:30 am',
                                                style: TextStyle(
                                                  color: AppColors.primarycolor,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  // Edit schedule functionality
                                                },
                                                style: TextButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 8,
                                                      ),
                                                  minimumSize:
                                                      Size.zero,
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                child: const Row(
                                                  children: [
                                                    Text(
                                                      'Edit Schedule',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors.activeButton
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward,
                                                      size: 16,
                                                      color: Color(
                                                        0xFF00BCD4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Car image (positioned at the bottom right)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(16),
                                      ),
                                      child: Image.asset(
                                        'assets/images/car.png',
                                        height: 60,
                                      ),
                                    ),
                                  ),

                                  // License plate
                                  Positioned(
                                    top: 42,
                                    right:
                                        10, // Positioned to the right of the car image
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        color: const Color(0xFFFFD54F),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        vehicleNumber,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height *
                                  0.02, // ~16px
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height * 0.02, // ~16px
                      ),

                      // Trip Details Card
                      const Expanded(child: TodaysTripCard()),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    bool showInfo = false,
    Color? valueColor,
    Color? subtitleColor,
    String? additionalText,
  }) {
    return Container(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width * 0.04,
      ), // ~16px
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.04, // ~16px
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: MediaQuery.of(context).size.width * 0.03, // ~14px
                ),
              ),
              if (showInfo) ...[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ), // ~4px
                SvgPicture.asset(
                  AppAssets.help,
                  color: Colors.grey[400],
                  height: MediaQuery.of(context).size.width * 0.045, // ~19px
                ),
              ],
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04), // ~8px
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width * 0.06, // ~28px
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.height * 0.02,
                  ), // ~6px
                  if (additionalText != null)
                    Text(
                      additionalText,
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width * 0.03, // ~17px
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02), // ~8px
              Text(
                subtitle,
                style: TextStyle(
                  color: subtitleColor ?? Colors.grey,
                  fontSize: MediaQuery.of(context).size.width * 0.03, // ~12px
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
