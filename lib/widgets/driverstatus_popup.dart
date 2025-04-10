
import 'package:breezodriver/core/utils%20copy/size_config.dart';
import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DriverStatusBanner extends StatelessWidget {
  final String driverId;
  final String vehicleDetails;
  final VoidCallback onViewTripPressed;
  final bool isVisible;

  const DriverStatusBanner({
    Key? key,
    required this.driverId,
    required this.vehicleDetails,
    required this.onViewTripPressed,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomNavHeight = SizeConfig.getProportionateScreenHeight(0);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: 0,
      right: 0,
      bottom: isVisible ? bottomNavHeight : -110,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionateScreenWidth(0),
        ),
        child: Container(
          alignment: Alignment.bottomCenter,
          height: SizeConfig.getProportionateScreenHeight(100),
          padding: EdgeInsets.only(
            top: SizeConfig.getProportionateScreenHeight(6),
          ),
          decoration: BoxDecoration(
            color: AppColors.activeButton,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.getProportionateScreenWidth(20)),
              topRight: Radius.circular(SizeConfig.getProportionateScreenWidth(20)),
            )
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your expected pickup time is 09:45 am',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.getProportionateScreenWidth(14),
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(3)),
                Container(
                  height: SizeConfig.getProportionateScreenHeight(
                    72,
                  ), // Slightly smaller

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.getProportionateScreenWidth(20)),
                      topRight: Radius.circular(SizeConfig.getProportionateScreenWidth(20)),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: SizeConfig.getProportionateScreenWidth(10),
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getProportionateScreenWidth(16),
                      vertical: SizeConfig.getProportionateScreenHeight(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Driver is on the way',
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.getProportionateScreenWidth(
                                        18,
                                      ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.getProportionateScreenHeight(
                                  2,
                                ),
                              ),
                              Text(
                                '$driverId • $vehicleDetails',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize:
                                      SizeConfig.getProportionateScreenWidth(
                                        14,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: onViewTripPressed,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.getProportionateScreenHeight(
                                1,
                              ),

                              horizontal:
                                  SizeConfig.getProportionateScreenWidth(17),
                            ),
                            backgroundColor: Colors.white,
                            fixedSize: Size(
                              SizeConfig.getProportionateScreenWidth(100),
                              SizeConfig.getProportionateScreenHeight(20),
                            ),
                            side: BorderSide(
                              color: AppColors.primarycolor.withOpacity(0.3),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                SizeConfig.getProportionateScreenWidth(30),
                              ),
                            ),
                            shadowColor: Colors.transparent,
                            surfaceTintColor: Colors.white,
                          ),
                          child: Text(
                            'View Trip',
                            style: TextStyle(
                              fontSize: SizeConfig.getProportionateScreenWidth(
                                15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
