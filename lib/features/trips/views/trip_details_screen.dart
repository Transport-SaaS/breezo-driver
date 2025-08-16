import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/core/utils/app_assets.dart';
import 'package:breezodriver/features/trips/models/trip_model.dart';
import 'package:breezodriver/features/trips/viewmodels/trip_details_viewmodel.dart';
import 'package:breezodriver/features/trips/views/trip_map_view.dart';
import 'package:breezodriver/features/trips/widgets/trip_bottom_sheet.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:breezodriver/widgets/info_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:breezodriver/features/trips/views/trip_rating_screen.dart';
import 'package:breezodriver/features/trips/viewmodels/trip_rating_viewmodel.dart';

import '../../../core/utils/utils.dart';
import '../viewmodels/trip_viewmodel.dart';

class TripDetailsScreen extends StatefulWidget {
  final TripModel trip;

  const TripDetailsScreen({Key? key, required this.trip}) : super(key: key);

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  // Keep track of the positions of the timeline dots
  final List<GlobalKey> _timelineDotKeys = [];
  bool _showMapView = false;
  late TripDetailsViewModel _viewModel;
  bool _hasNavigatedToRating = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTripDetails();
    // Create the view model directly
    _viewModel = TripDetailsViewModel(widget.trip);

    // Add listener to rebuild UI when viewModel changes
    _viewModel.addListener(_onViewModelChanged);
    
  }

  void loadTripDetails() async {
    setState(() {
      isLoading = true;
    });

    final tripViewModel = Provider.of<TripViewModel>(context, listen: false);
    await tripViewModel.loadTripDetails(widget.trip, false);

    // Initialize keys for each timeline point (start + passengers + destination)
    _timelineDotKeys.clear();
    for (int i = 0; i < widget.trip.passengerList.length + 2; i++) {
      _timelineDotKeys.add(GlobalKey());
    }
    setState(() {
      isLoading = false;
    });
  }
  
  void _onViewModelChanged() {
    if (mounted) {
      // Check if we need to navigate to rating screen
      if (_viewModel.status == TripStatus.completed && !_hasNavigatedToRating) {
        _hasNavigatedToRating = true;
        
        // Use a post-frame callback to avoid build errors
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Create a dedicated rating ViewModel
          final ratingViewModel = TripRatingViewModel(_viewModel.trip);
          
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => TripRatingScreen(viewModel: ratingViewModel),
            ),
          ).then((_) {
            // Allow navigation again if the user comes back
            _hasNavigatedToRating = false;
          });
        });
      }
      
      setState(() {});
    }
  }
  
  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
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
          'Trip ID: ${_viewModel.trip.id}',
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
              onPressed: () {
                setState(() {
                  _showMapView = !_showMapView;
                });
              },
              icon: Icon(_showMapView ? Icons.list : Icons.map_outlined),
              label: Text(_showMapView ? 'List View' : 'Map View'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primarycolor,
                side: const BorderSide(color: AppColors.primarycolor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          // DEV/TEST ONLY: Simulation button
          if (const bool.fromEnvironment('dart.vm.product') == false)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {
                  // Simulate trip completion for testing
                  setState(() {
                    _viewModel.simulateAllPickupsComplete();
                  });
                },
                icon: const Icon(Icons.fast_forward),
                tooltip: 'Simulate trip completion',
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          if (!_showMapView)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'Assigned at: ${Utils.formatTime(_viewModel.trip.assignedAt)}',
                  //   style: TextStyle(
                  //     color: Colors.grey[600],
                  //     fontSize: 14,
                  //   ),
                  // ),
                  SizedBox(height: 16),
                ],
              ),
            ),

          // Main content area - conditionally show timeline or map
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
          Expanded(
            child:
                _showMapView
                    ? TripMapView(
                      trip: _viewModel.trip,
                      viewModel: _viewModel,
                    )
                    : _buildTripTimeline(_viewModel),
          ),

          // Bottom sheet - use the extracted widget
          TripBottomSheet(viewModel: _viewModel),
        ],
      ),
    );
  }

  Widget _buildTripTimeline(TripDetailsViewModel viewModel) {
    // Determine which passengers have been picked up based on trip status
    int pickedUpCount = viewModel.status == TripStatus.assigned ? 0 : 2;

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
              _buildTimelineDot(
                isCompleted: true,
                isFirst: true,
                key: _timelineDotKeys[0],
              ),

              // Line from Start to first passenger
              _buildTimelineLine(
                isCompleted: true,
                startKey: _timelineDotKeys[0],
                endKey: _timelineDotKeys[1],
              ),

              // Generate dots and lines for passengers
              ...List.generate(viewModel.trip.passengerList.length, (index) {
                final bool isPickedUp = index < pickedUpCount;
                final bool isLast =
                    index == viewModel.trip.passengerList.length - 1;
                final int dotKeyIndex =
                    index + 1; // +1 because index 0 is the start

                return Column(
                  children: [
                    // Passenger dot
                    _buildTimelineDot(
                      isCompleted: isPickedUp,
                      key: _timelineDotKeys[dotKeyIndex],
                    ),

                    // Line to next stop (if not the last passenger)
                    if (!isLast)
                      _buildTimelineLine(
                        isCompleted: index < pickedUpCount - 1,
                        startKey: _timelineDotKeys[dotKeyIndex],
                        endKey: _timelineDotKeys[dotKeyIndex + 1],
                      ),
                  ],
                );
              }),

              // Line to destination
              _buildTimelineLine(
                isCompleted: false,
                startKey: _timelineDotKeys[viewModel.trip.passengerList.length],
                endKey:
                    _timelineDotKeys[viewModel.trip.passengerList.length + 1],
              ),

              // Last dot (Destination)
              _buildTimelineDot(
                isCompleted: false,
                isLast: true,
                key: _timelineDotKeys[viewModel.trip.passengerList.length + 1],
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
                time: Utils.formatTime(viewModel.trip.startTime),
                title: 'Start',
                address: viewModel.trip.startAddress,
                isStart: true,
                isEnd: false,
                isCompleted: true,
                isLast: false,
              ),

              // Passengers
              ...List.generate(viewModel.trip.passengerList.length, (index) {
                final passenger = viewModel.trip.passengerList[index];
                final bool isPickedUp = index < pickedUpCount;

                return _buildPassengerItem(
                  passenger: passenger,
                  isPickedUp: isPickedUp,
                  showCallButton:
                      viewModel.status == TripStatus.accepted ||
                      viewModel.status == TripStatus.readyToStart ||
                      viewModel.status == TripStatus.inProgress,
                );
              }),

              // Destination
              _buildTimelineItem(
                time: Utils.formatTime(viewModel.trip.endTime),
                title: 'Destination',
                address: viewModel.trip.endAddress,
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
    Key? key,
  }) {
    const Color activeColor = Color(0xFF00BFA5); // Teal color
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
    GlobalKey? endKey,
  }) {
    const Color activeColor = Color(0xFF00BFA5); // Teal color
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
            final RenderBox? startBox =
                startKey.currentContext?.findRenderObject() as RenderBox?;
            final RenderBox? endBox =
                endKey.currentContext?.findRenderObject() as RenderBox?;

            if (startBox != null && endBox != null) {
              final Offset startPos = startBox.localToGlobal(Offset.zero);
              final Offset endPos = endBox.localToGlobal(Offset.zero);

              // Calculate the distance between the centers of the dots
              lineHeight =
                  (endPos.dy - startPos.dy).abs() -
                  20; // Subtract dot heights + margins

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
    const Color activeColor = AppColors.primarycolor;
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
              color:
                  isCompleted
                      ? activeColor.withOpacity(0.2)
                      : Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted ? activeColor : inactiveColor,
                width: 1.5,
              ),
            ),
            child: Center(
              child:
                  isStart
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
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
    bool showCallButton = false,
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
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),

          // Right side: Call button and time
          Row(
            children: [
              // Only show call button if trip is accepted/in progress
              if (showCallButton)
                Container(
                  height: 32,
                  width: 32,
                  margin: const EdgeInsets.only(top: 0, right: 8),
                  decoration: const BoxDecoration(
                    color: AppColors.primarycolorDark,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.call, color: Colors.white, size: 18),
                    onPressed: () {
                      // Handle call action
                    },
                  ),
                ),

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
}
