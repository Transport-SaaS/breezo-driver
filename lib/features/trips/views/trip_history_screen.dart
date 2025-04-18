import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/trips/models/trip_model.dart';
import 'package:breezodriver/widgets/scheduled_trip_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  int _selectedTabIndex = 0;
  late DateTime _selectedDate;
  final PageController _monthController = PageController();
  
  // Map to store trips by status
  late Map<String, List<TripModel>> _tripsByStatus;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Start with current date
    _initializeTrips();
  }

  String get formattedMonth {
    return DateFormat('MMMM, yyyy').format(_selectedDate);
  }

  void _showMonthPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Month',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            SizedBox(
              height: 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = DateTime(2024, index + 1);
                  final isSelected = month.month == _selectedDate.month;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedDate = DateTime(_selectedDate.year, index + 1);
                      });
                      Navigator.pop(context);
                      _initializeTrips(); // Refresh trips for new month
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primarycolor : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppColors.primarycolor : Colors.grey.shade300,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        DateFormat('MMM').format(month),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateMonth(int monthDelta) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + monthDelta,
        _selectedDate.day,
      );
      _initializeTrips(); // Refresh trips for new month
    });
  }

  void _initializeTrips() {
    // Sample data - replace with actual data later
    // Here we could filter trips based on _selectedDate
    _tripsByStatus = {
      'Assigned': List.generate(3, (index) => _createSampleTrip('Assigned')),
      'Accepted': List.generate(2, (index) => _createSampleTrip('Accepted')),
      'Missed': List.generate(1, (index) => _createSampleTrip('Missed')),
      'Completed': List.generate(7, (index) => _createSampleTrip('Completed')),
    };
  }

  TripModel _createSampleTrip(String status) {
    return TripModel(
      id: '1',
      status: status,
      assignedAt: '11:23am, Jan 24, 2025',
      startTime: '09:45',
      startAddress: 'Building No. 134, Mahalaxmi Nagar, Naga...',
      endTime: '11:00',
      endAddress: 'A2, Block-C, ABC Techpark, Maga...',
      duration: '01h 13m',
      distance: '20 kms',
      passengers: 4,
      acceptBeforeTime: status == 'Assigned' ? '11:45 AM' : status,
      passengerList: [],
      endLocation: '',
      startLocation: 'Building No. 134, Mahalaxmi Nagar',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Trip History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _showMonthPicker,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    'Month',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey.shade700,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Month selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _navigateMonth(-1),
                ),
                Text(
                  formattedMonth,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primarycolor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _navigateMonth(1),
                ),
              ],
            ),
          ),

          // Status tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatusTab('Assigned', _tripsByStatus['Assigned']?.length ?? 0, 0),
                _buildStatusTab('Accepted', _tripsByStatus['Accepted']?.length ?? 0, 1),
                _buildStatusTab('Missed', _tripsByStatus['Missed']?.length ?? 0, 2),
                _buildStatusTab('Completed', _tripsByStatus['Completed']?.length ?? 0, 3),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Date header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat('MMMM d, yyyy').format(_selectedDate),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),

          // Trip list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _getCurrentTrips().length,
              itemBuilder: (context, index) {
                final trip = _getCurrentTrips()[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ScheduledTripCard(
                    assignedAt: trip.assignedAt,
                    startTime: trip.startTime,
                    startLocation: trip.startAddress,
                    endTime: trip.endTime,
                    endLocation: trip.endAddress,
                    duration: trip.duration,
                    distance: trip.distance,
                    passengers: trip.passengers,
                    acceptBeforeTime: trip.acceptBeforeTime,
                    onTap: () {
                      // Handle trip tap
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

  Widget _buildStatusTab(String title, int count, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarycolor : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primarycolor : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$title ($count)',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  List<TripModel> _getCurrentTrips() {
    final statuses = ['Assigned', 'Accepted', 'Missed', 'Completed'];
    final selectedStatus = statuses[_selectedTabIndex];
    return _tripsByStatus[selectedStatus] ?? [];
  }
} 