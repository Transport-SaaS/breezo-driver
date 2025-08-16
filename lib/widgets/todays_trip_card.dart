import 'package:breezodriver/core/utils%20copy/size_config.dart';
import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/core/utils/utils.dart';
import 'package:flutter/material.dart';
import '../features/trips/viewmodels/trip_viewmodel.dart';
import 'scheduled_trip_card.dart';
import 'package:provider/provider.dart';
import 'package:breezodriver/features/trips/models/trip_model.dart';
import 'package:breezodriver/features/trips/views/trip_details_screen.dart';
import 'package:breezodriver/features/trips/data/trip_data.dart';

class TodaysTripCard extends StatefulWidget {
  const TodaysTripCard({super.key});

  @override
  State<TodaysTripCard> createState() => _TodaysTripCardState();
}

class _TodaysTripCardState extends State<TodaysTripCard> {
  int _selectedTabIndex = 0;
  
  // Map to store trips by status
  late Map<String, List<TripModel>> _tripsByStatus;
  
  @override
  void initState() {
    super.initState();
    // Initialize trips data
    _initializeTrips();
  }
  
  void _initializeTrips() async {
    final tripViewModel = Provider.of<TripViewModel>(context, listen: false);
    final allTrips = tripViewModel.plannedTrips + tripViewModel.pastTrips;
    
    // Group trips by status and organize tabs
    _tripsByStatus = {
      'Assigned': allTrips.where((trip) => trip.status == 'assigned').toList(),
      'Accepted': allTrips.where((trip) => trip.status == 'accepted').toList(),
      // 'Missed': allTrips.where((trip) => trip.status == 'Missed').toList(),
      'Completed': allTrips.where((trip) => trip.status == 'completed').toList(),
    };
  }

  List<String> get _tabTitles => _tripsByStatus.keys.toList();

  @override
  Widget build(BuildContext context) {
    // Get screen height
    final screenHeight = MediaQuery.of(context).size.height;
    // Calculate approximate height
    final containerHeight = screenHeight * 0.8; // Takes 80% of screen height

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
          
          // Tabs row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_tabTitles.length, (index) {
                final title = _tabTitles[index];
                final count = _tripsByStatus[title]?.length ?? 0;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == index 
                            ? AppColors.primarycolorDark 
                            : Colors.white,
                        border: Border.all(
                          color: _selectedTabIndex == index
                              ? AppColors.primarycolorDark
                              : AppColors.primarycolor.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$title ($count)',
                        style: TextStyle(
                          color: _selectedTabIndex == index ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Content area - scrollable list of trips
          Expanded(
            child: _getCurrentTrips().isEmpty 
              ? Center(
                  child: Text(
                    'No ${_tabTitles[_selectedTabIndex].toLowerCase()} trips',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: _getCurrentTrips().length,
                  itemBuilder: (context, index) {
                    final trip = _getCurrentTrips()[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ScheduledTripCard(
                        assignedAt: Utils.formatTime(trip.assignedAt),
                        startTime: Utils.formatTime(trip.startTime),
                        startLocation: trip.startAddress,
                        endTime: Utils.formatTime(trip.endTime),
                        endLocation: trip.endAddress,
                        duration: Utils.getHourAndMinuteFromSeconds(int.parse(trip.duration)),
                        distance: trip.distance,
                        passengers: trip.passengers,
                        acceptBeforeTime: trip.acceptBeforeTime,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TripDetailsScreen(trip: trip),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
  
  // Helper to get current trips based on selected tab
  List<TripModel> _getCurrentTrips() {
    final selectedStatus = _tabTitles[_selectedTabIndex];
    return _tripsByStatus[selectedStatus] ?? [];
  }
}
