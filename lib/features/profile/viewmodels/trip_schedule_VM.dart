import 'package:breezodriver/features/profile/models/tripscheduleModel.dart';
import 'package:flutter/foundation.dart';


class TripScheduleViewModel extends ChangeNotifier {
  List<TripSchedule> _upcomingSchedules = [];
  List<TripSchedule> _pastSchedules = [];
  bool _isLoading = true;

  List<TripSchedule> get upcomingSchedules => _upcomingSchedules;
  List<TripSchedule> get pastSchedules => _pastSchedules;
  bool get isLoading => _isLoading;

  Future<void> loadTrips() async {
    // Simulate loading delay
    await Future.delayed(Duration(seconds: 2));
    
    // Create dummy data for upcoming trips
    final now = DateTime.timestamp();
    
    // Upcoming trips - next 3 days
    _upcomingSchedules = [
      // TripSchedule(
      //   date: now.add(Duration(days: 1)),
      //   trips: [
      //     Trip(
      //       isCompleted: false,
      //       isScheduled: true,
      //       time: "09:45 AM",
      //       location: "Home",
      //       address: "Building No. 134, Mahalaxmi Nagar, Nagasandra",
      //       type: "Home",
      //       lockDuration: Duration(hours: 2, minutes: 30),
      //     ),
      //     Trip(
      //       isCompleted: false,
      //       isScheduled: true,
      //       time: "19:00 PM",
      //       location: "Office",
      //       address: "A2, Block-C, ABC Techpark, Magarpatta",
      //       type: "Office",
      //       lockDuration: Duration(hours: 6),
      //     ),
      //   ],
      // ),
      // TripSchedule(
      //   date: now.add(Duration(days: 2)),
      //   trips: [
      //     Trip(
      //       isCompleted: false,
      //       isScheduled: true,
      //       time: "09:45 AM",
      //       location: "Home",
      //       address: "Building No. 134, Mahalaxmi Nagar, Nagasandra",
      //       type: "Home",
      //       lockDuration: Duration(hours: 26, minutes: 30),
      //     ),
      //   ],
      // ),
      // TripSchedule(
      //   date: now.add(Duration(days: 3)),
      //   trips: [
      //     Trip(
      //       isCompleted: false,
      //       isScheduled: true,
      //       time: "09:45 AM",
      //       location: "Home",
      //       address: "Building No. 134, Mahalaxmi Nagar, Nagasandra",
      //       type: "Home",
      //       lockDuration: Duration(hours: 50, minutes: 30),
      //     ),
      //     Trip(
      //       isCompleted: false,
      //       isScheduled: true,
      //       time: "19:00 PM",
      //       location: "Office",
      //       address: "A2, Block-C, ABC Techpark, Magarpatta",
      //       type: "Office",
      //       lockDuration: Duration(hours: 54),
      //     ),
      //   ],
      // ),
    ];

    // Past trips - last 3 days
    _pastSchedules = [
      TripSchedule(
        date: now.subtract(Duration(days: 1)),
        trips: [
          Trip(
            isCompleted: true,
              isScheduled: false,
            time: "09:45 AM",
            location: "Home",
            address: "Building No. 134, Mahalaxmi Nagar, Nagasandra",
            type: "Home",
            lockDuration: Duration.zero,
          ),
          Trip(
            isCompleted: true,
            isScheduled: false,
            time: "19:00 PM",
            location: "Office",
            address: "A2, Block-C, ABC Techpark, Magarpatta",
            type: "Office",
            lockDuration: Duration.zero,
          ),
        ],
      ),
      TripSchedule(
        date: now.subtract(Duration(days: 2)),
        trips: [
          Trip(
            isCompleted: true,
            isScheduled: false,
            time: "09:45 AM",
            location: "Home",
            address: "Building No. 134, Mahalaxmi Nagar, Nagasandra",
            type: "Home",
            lockDuration: Duration.zero,
          ),
        ],
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }
}