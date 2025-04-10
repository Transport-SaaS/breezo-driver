
import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'scheduled_trip_card.dart';
import 'package:provider/provider.dart';


class TodaysTripCard extends StatefulWidget {
  const TodaysTripCard({super.key});

  @override
  State<TodaysTripCard> createState() => _TodaysTripCardState();
}

class _TodaysTripCardState extends State<TodaysTripCard> {
  bool isToOffice = true;

  @override
  Widget build(BuildContext context) {
    // Get screen height
    final screenHeight = MediaQuery.of(context).size.height;
    // Calculate approximate height (adjust multiplier as needed)
    final containerHeight = screenHeight * 0.8; // Takes 80% of screen height

    // // Get the DriverStatusViewModel
    // final driverStatusModel = Provider.of<DriverStatusViewModel>(
    //   context,
    //   listen: false,
    // );

    return Container(
      width: double.infinity,
      height: containerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's trips",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Toggle buttons row
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isToOffice = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isToOffice ? AppColors.primarycolorDark : Colors.white,
                    border: Border.all(
                      color:
                          isToOffice
                              ? AppColors.primarycolorDark
                              : AppColors.primarycolor.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'To Office',
                    style: TextStyle(
                      color: isToOffice ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isToOffice = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color:
                        !isToOffice ? AppColors.primarycolorDark : Colors.white,
                    border: Border.all(
                      color:
                          !isToOffice
                              ? AppColors.primarycolorDark
                              : AppColors.primarycolor.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'From Office',
                    style: TextStyle(
                      color: !isToOffice ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content area
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child:
                isToOffice
                    ? ScheduledTripCard(
                      isCompleted: false,
                      date: 'MON, 23 JAN 2025',
                      startTime: '09:45',
                      startLocation: 'Home',
                      startAddress:
                          'Building No. 134, Mahalaxmi Nagar, Nagas...',
                      endTime: '19:00',
                      endLocation: 'Office',
                      endAddress: 'A2, Block-C, ABC Techpark, Magarpattam...',
                      lockTime: '1:23 min',
                      onChangePressed: () {
                        // // Toggle scheduled status
                        // bool currentStatus = driverStatusModel.isScheduled;
                        // driverStatusModel.setScheduledStatus(!currentStatus);
                      },
                      onMorePressed: () {},
                      isScheduled:
                          true, // Use the value from ViewModel
                    )
                    : const Center(
                      child: Text(
                        'No trips scheduled',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
