import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/core/utils/app_assets.dart';
import 'package:breezodriver/features/trips/models/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

class TripDetailsScreen extends StatefulWidget {
  final TripModel trip;

  const TripDetailsScreen({Key? key, required this.trip}) : super(key: key);

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  // Keep track of the positions of the timeline dots
  final List<GlobalKey> _timelineDotKeys = [];
  
  @override
  void initState() {
    super.initState();
    // Initialize keys for each timeline point (start + passengers + destination)
    _timelineDotKeys.clear();
    for (int i = 0; i < widget.trip.passengerList.length + 2; i++) {
      _timelineDotKeys.add(GlobalKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Trip ID: ${widget.trip.id}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map_outlined),
              label: const Text('Map View'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primarycolor,
                side: BorderSide(color: AppColors.primarycolor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assigned at: ${widget.trip.assignedAt}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          
          // Trip timeline
          Expanded(
            child: _buildTripTimeline(),
          ),
          
          // Bottom sheet
          _buildBottomActionSheet(),
        ],
      ),
    );
  }

  Widget _buildTripTimeline() {
    // Determine which passengers have been picked up (for demo, assume first two are picked up)
    final int pickedUpCount = 2; // This could be dynamic based on trip status
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column with the timeline line and dots
        Container(
          width: 30,
          padding: const EdgeInsets.only(top: 0), // To align with the content
          child: Column(
            children: [
              // First dot (Start)
              _buildTimelineDot(isCompleted: true, isFirst: true, key: _timelineDotKeys[0]),
              
              // Line from Start to first passenger
              _buildTimelineLine(
                isCompleted: true, 
                startKey: _timelineDotKeys[0], 
                endKey: _timelineDotKeys[1]
              ),
              
              // Generate dots and lines for passengers
              ...List.generate(widget.trip.passengerList.length, (index) {
                final bool isPickedUp = index < pickedUpCount;
                final bool isLast = index == widget.trip.passengerList.length - 1;
                final int dotKeyIndex = index + 1; // +1 because index 0 is the start
                
                return Column(
                  children: [
                    // Passenger dot
                    _buildTimelineDot(
                      isCompleted: isPickedUp, 
                      key: _timelineDotKeys[dotKeyIndex]
                    ),
                    
                    // Line to next stop (if not the last passenger)
                    if (!isLast) 
                      _buildTimelineLine(
                        isCompleted: index < pickedUpCount - 1,
                        startKey: _timelineDotKeys[dotKeyIndex],
                        endKey: _timelineDotKeys[dotKeyIndex + 1]
                      ),
                  ],
                );
              }),
              
              // Line to destination
              _buildTimelineLine(
                isCompleted: false,
                startKey: _timelineDotKeys[widget.trip.passengerList.length],
                endKey: _timelineDotKeys[widget.trip.passengerList.length + 1]
              ),
              
              // Last dot (Destination)
              _buildTimelineDot(
                isCompleted: false, 
                isLast: true,
                key: _timelineDotKeys[widget.trip.passengerList.length + 1]
              ),
            ],
          ),
        ),
        
        // Right column with the content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(0),
            physics: const BouncingScrollPhysics(),
            children: [
              // Start location
              _buildTimelineItem(
                time: widget.trip.startTime,
                title: 'Start',
                address: widget.trip.startAddress,
                isStart: true,
                isEnd: false,
                isCompleted: true,
                isLast: false,
              ),
              
              // Passengers
              ...List.generate(widget.trip.passengerList.length, (index) {
                final passenger = widget.trip.passengerList[index];
                final bool isPickedUp = index < pickedUpCount;
                
                return _buildPassengerItem(
                  passenger: passenger,
                  isPickedUp: isPickedUp,
                );
              }),
              
              // Destination
              _buildTimelineItem(
                time: widget.trip.endTime,
                title: 'Destination',
                address: widget.trip.endAddress,
                isStart: false,
                isEnd: true,
                isCompleted: false,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineDot({
    required bool isCompleted, 
    bool isFirst = false, 
    bool isLast = false,
    Key? key
  }) {
    final Color activeColor = const Color(0xFF00BFA5); // Teal color
    final Color inactiveColor = Colors.grey.shade300;
    
    return Container(
      key: key,
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isCompleted ? activeColor : inactiveColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTimelineLine({
    required bool isCompleted, 
    GlobalKey? startKey, 
    GlobalKey? endKey
  }) {
    final Color activeColor = const Color(0xFF00BFA5); // Teal color
    final Color inactiveColor = Colors.grey.shade300;
    
    // Default height if we can't measure
    double lineHeight = 50;
    
    // Calculate height based on the position of the two dots if keys are provided
    if (startKey != null && endKey != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // This will update after the first build when widgets have been laid out
          // and we can calculate actual positions
          try {
            final RenderBox? startBox = startKey.currentContext?.findRenderObject() as RenderBox?;
            final RenderBox? endBox = endKey.currentContext?.findRenderObject() as RenderBox?;
            
            if (startBox != null && endBox != null) {
              final Offset startPos = startBox.localToGlobal(Offset.zero);
              final Offset endPos = endBox.localToGlobal(Offset.zero);
              
              // Calculate the distance between the centers of the dots
              lineHeight = (endPos.dy - startPos.dy).abs() - 20; // Subtract dot heights + margins
              
              // Ensure minimum height
              if (lineHeight < 20) lineHeight = 20;
            }
          } catch (e) {
            // Fallback to default if measurement fails
            lineHeight = 50;
          }
        });
      });
    }
    
    return Container(
      width: 2,
      height: lineHeight,
      color: isCompleted ? activeColor : inactiveColor,
    );
  }

  Widget _buildTimelineItem({
    required String time,
    required String title,
    required String address,
    required bool isStart,
    required bool isEnd,
    required bool isCompleted,
    required bool isLast,
  }) {
    // Using teal color for active items as shown in the screenshot
    final Color activeColor = const Color(0xFF00BFA5);
    final Color inactiveColor = Colors.grey.shade400;
    
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: isCompleted ? activeColor.withOpacity(0.2) : Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted ? activeColor : inactiveColor,
                width: 1.5,
              ),
            ),
            child: Center(
              child: isStart 
                  ? SvgPicture.asset(
                      AppAssets.homeSchedule,
                      width: 14,
                      height: 14,
                      color: isCompleted ? activeColor : inactiveColor,
                    )
                  : isEnd
                      ? SvgPicture.asset(
                          AppAssets.business,
                          width: 14,
                          height: 14,
                          color: isCompleted ? activeColor : inactiveColor,
                        )
                      : Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: isCompleted ? activeColor : inactiveColor,
                        ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Middle: Content (Title and Address)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Right side: Time
          Container(
            width: 52,
            margin: const EdgeInsets.only(top: 4),
            child: Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerItem({
    required Passenger passenger,
    required bool isPickedUp,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CircleAvatar - positioned to the right of the timeline
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _getAvatarColor(passenger.initials),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                passenger.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Middle: Content (Name and Address)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  passenger.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  passenger.address,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Right side: Time
          Container(
            width: 52,
            margin: const EdgeInsets.only(top: 4),
            child: Text(
              passenger.pickupTime,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
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

  Widget _buildBottomActionSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Wait or start message - with rounded corners
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF7F1D1D), // Dark red color from screenshot
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Wait or start the next trip!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Delay',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildTimeDigit('0'),
                      _buildTimeDigit('0'),
                      const Text(
                        ':',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildTimeDigit('0'),
                      _buildTimeDigit('2'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Pickup route info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pickup Route',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildRouteInfoChip(Icons.access_time, '01h 13m'),
                    const SizedBox(width: 8),
                    _buildRouteInfoChip(Icons.directions_car_outlined, '20 kms'),
                    const SizedBox(width: 8),
                    _buildRouteInfoChip(Icons.people_outline, '4'),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Reject',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00BFA5), // Teal color from screenshot
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Accept',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDigit(String digit) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        digit,
        style: const TextStyle(
          color: Color(0xFF7F1D1D), // Dark red color from screenshot
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRouteInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}