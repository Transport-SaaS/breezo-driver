import 'package:breezodriver/core/utils%20copy/size_config.dart';
import 'package:breezodriver/core/utils/app_assets.dart';
import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/widgets/todays_trip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String address = 'Building No. 134, Mahalaxmi Nagar, Nagasandra, Bangalore';

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
          Icon(
            Icons.menu,
            color: Colors.white,
            size: MediaQuery.of(context).size.width * 0.06,
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
                  'Home',
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
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffFFEAAC),
                                                    border: Border.all(
                                                      color: Colors.amber,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15
                                                        )
                                                  ),
                                                  child: const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                        size: 16,
                                                      ),
                                                      SizedBox(width: 2),
                                                      Text(
                                                        '4.2',
                                                        style: TextStyle(
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

                                            SizedBox(width: 10), // ~4px

                                            // Driver info and schedule
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Driver name and online status
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Rajesh Munna',
                                                        style: TextStyle(
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
                                                  const Text(
                                                    'White Tata Indigo',
                                                    style: TextStyle(
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
                                                        child: Row(
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
                                      borderRadius: BorderRadius.only(
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
                                        color: Color(0xFFFFD54F),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'KA 02 AA 2134',
                                        style: TextStyle(
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
