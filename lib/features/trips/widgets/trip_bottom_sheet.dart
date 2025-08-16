import 'package:breezodriver/core/utils%20copy/size_config.dart';
import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/core/utils/utils.dart';
import 'package:breezodriver/features/trips/models/trip_model.dart';
import 'package:breezodriver/features/trips/viewmodels/trip_details_viewmodel.dart';
import 'package:breezodriver/features/trips/widgets/otp_verification_modal.dart';
import 'package:breezodriver/features/trips/widgets/trip_rejection_modal.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:breezodriver/widgets/info_chip.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TripBottomSheet extends StatelessWidget {
  final TripDetailsViewModel viewModel;

  const TripBottomSheet({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (viewModel.status == TripStatus.destinationReached) {
      return _buildDestinationReachedBottomSheet(context);
    } else if (viewModel.status == TripStatus.inProgress) {
      return _buildInProgressBottomSheet(context);
    } else if (viewModel.status == TripStatus.accepted ||
        viewModel.status == TripStatus.readyToStart) {
      return _buildAcceptedBottomSheet(context);
    } else {
      return _buildAssignedBottomSheet(context);
    }
  }

  Widget _buildAssignedBottomSheet(BuildContext context) {
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
            decoration: BoxDecoration(
              color:
                  viewModel.status == TripStatus.assigned
                      ? const Color(0xFF6A121B)
                      : const Color(0xFF126E5F),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  viewModel.status == TripStatus.assigned
                      ? 'Wait or start the next trip!'
                      : 'Start your trip after',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text(
                        viewModel.status == TripStatus.assigned
                            ? 'Delay'
                            : 'Getting Ready',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildTimeDigit(viewModel.formattedDelay[0]),
                      _buildTimeDigit(viewModel.formattedDelay[1]),
                      const Text(
                        ':',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildTimeDigit(viewModel.formattedDelay[3]),
                      _buildTimeDigit(viewModel.formattedDelay[4]),
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
                Text(
                  viewModel.trip.isToBase == true ? 'Drop Route':'Pickup Route',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    buildInfoChip(
                      Icons.access_time,
                      Utils.getHourAndMinuteFromSeconds(int.parse(viewModel.trip.duration)),
                      Colors.grey.shade200,
                      Colors.grey.shade800,
                    ),
                    const SizedBox(width: 8),
                    buildInfoChip(
                      Icons.directions_car_outlined,
                      viewModel.trip.distance,
                      Colors.grey.shade200,
                      Colors.grey.shade800,
                    ),
                    const SizedBox(width: 8),
                    buildInfoChip(
                      Icons.people_outline,
                      viewModel.trip.passengerList.length.toString(),
                      Colors.grey.shade200,
                      Colors.grey.shade800,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:  8.0, vertical: 14),
                  child: Divider(
                    color: Colors.grey.shade300,
                    height: 1,
                  ),
                ),

                // Action buttons
                viewModel.status == TripStatus.assigned
                    ? Row(
                      children: [
                        Expanded(
                          child: CommonButton(
                            label: 'Reject',
                            onPressed:
                                viewModel.isLoadingAction
                                    ? null
                                    : () => _showRejectionModal(context),
                            activeColor: Colors.red,
                            inactiveColor: Colors.grey.shade300,
                            isActive: !viewModel.isLoadingAction,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CommonButton(
                            label: 'Accept',
                            onPressed:
                                viewModel.isLoadingAction
                                    ? null
                                    : () => viewModel.acceptTrip(),
                            activeColor: AppColors.activeButton,
                            inactiveColor: Colors.grey.shade300,
                            isActive: !viewModel.isLoadingAction,
                          ),
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Options menu
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                          ),
                          height: 45,
                          width: 45,
                          child: IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              _showMoreOptionsModal(context);
                            },
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Start Trip button
                        Expanded(
                          child: CommonButton(
                            label: 'Start Trip',
                            onPressed:
                                viewModel.isLoadingAction || !viewModel.canStartTrip
                                    ? null
                                    : () => viewModel.startTrip(),
                            activeColor: AppColors.activeButton,
                            inactiveColor: Colors.grey.shade300,
                            isActive: !viewModel.isLoadingAction && viewModel.canStartTrip,
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

  void _showRejectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TripRejectionModal(
          // title: "Cancel Trip",
          // subtitle1: "You can't cancel the trip after accepting it. If you cancel now, a ",
          // subtitle2: "",
          // richText: "penalty will be charged.",
          // buttonText: "Cancel Trip",
          viewModel: viewModel,
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }
   void _showCancelTripModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TripRejectionModal(
          title: "Cancel Trip",
          subtitle1: "You can't cancel the trip after accepting it. If you cancel now, a ",
          subtitle2: "",
          richText: "penalty will be charged.",
          buttonText: "Cancel Trip",
          viewModel: viewModel,
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showMoreOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   // Menu option items

            SizedBox(
              width: double.infinity,
              child: CommonButton(label: "Report an issue", onPressed: () {
                Navigator.pop(context);
                // Call support action
              }, isActive: true,
              activeColor: AppColors.primarycolor,
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: CommonButton(label: "Cancel Trip", onPressed: () {
                  Navigator.pop(context);
                  _showCancelTripModal(context);
                }, isActive: true,
                activeColor: Colors.red,
                ),
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CommonButton(label: "Go Back", onPressed: () {
                Navigator.pop(context);
                // Open support chat
              }, isActive: true,
              textColor: AppColors.primarycolor,
              borderColor: Colors.grey.shade700,
              activeColor: Colors.white,
                        
              ),
            ),
                ],
              ),
            ),
            

            
          
            


         
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptedBottomSheet(BuildContext context) {
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
          // Pickup header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF126E5F),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'You\'re expected to arrive at ${viewModel.trip.startTime}',
                //   style: const TextStyle(color: Colors.white, fontSize: 12),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Start your trip after',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Getting Ready',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildTimeDigit(viewModel.formattedDelay[0]),
                              _buildTimeDigit(viewModel.formattedDelay[1]),
                              const Text(
                                ':',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildTimeDigit(viewModel.formattedDelay[3]),
                              _buildTimeDigit(viewModel.formattedDelay[4]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Pickup options
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Trip info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.trip.isToBase == true ? 'Drop Route':'Pickup Route',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              buildInfoChip(
                                Icons.access_time,
                                viewModel.trip.duration,
                                Colors.grey.shade200,
                                Colors.grey.shade800,
                              ),
                              const SizedBox(width: 8),
                              buildInfoChip(
                                Icons.directions_car_outlined,
                                viewModel.trip.distance,
                                Colors.grey.shade200,
                                Colors.grey.shade800,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Three dots menu
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.more_horiz, color: Colors.black),
                        onPressed: () {
                          _showMoreOptionsModal(context);
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:  8.0, vertical: 14),
                  child: Divider(
                    color: Colors.grey.shade300,
                    height: 1,
                  ),
                ),

                // Start trip button
                SizedBox(
                  width: double.infinity,
                  child: CommonButton(
                    label: 'Start Trip',
                    onPressed:
                        (viewModel.isLoadingAction || !viewModel.canStartTrip)
                            ? null
                            : () => viewModel.startTrip(),
                    activeColor: AppColors.primarycolor,
                    inactiveColor: Colors.grey.shade300,
                    isActive:
                        !viewModel.isLoadingAction && viewModel.canStartTrip,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInProgressBottomSheet(BuildContext context) {
    final pageController = PageController(viewportFraction: 0.95);
    final remainingPassengers =
        viewModel.trip.passengerList
            .where((p) => !viewModel.pickedUpPassengerIds.contains(p.id))
            .toList();

    // Determine if the trip is delayed (for UI purposes)
    // In a real app, this would come from the backend
    final bool isDelayed = !viewModel.hasArrivedAtLocation && viewModel.arrivalSeconds <= 45;

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
          // Arrival notification
          if (viewModel.showArrivedNotification)
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, -20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "You have arrived at the passenger's location",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

          // Next Pickup header with color change based on arrival status
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: viewModel.hasArrivedAtLocation
                  ? Colors.green.shade700 // Green when arrived
                  : AppColors.primarycolor, // Purple when en route
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      viewModel.hasArrivedAtLocation
                          ? 'Pickup Address'
                          : 'Next Pickup',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    // Only show countdown timer when not arrived
                    if (!viewModel.hasArrivedAtLocation)
                      Row(
                        children: [
                          Text(
                            'Waiting',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildTimeDigit(viewModel.formattedArrivalTime[0]),
                          _buildTimeDigit(viewModel.formattedArrivalTime[1]),
                          const Text(
                            ':',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildTimeDigit(viewModel.formattedArrivalTime[3]),
                          _buildTimeDigit(viewModel.formattedArrivalTime[4]),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    viewModel.hasArrivedAtLocation
                        ? "You've arrived at the location"
                        : 'You\'re expected to arrive at ${remainingPassengers.isNotEmpty ? remainingPassengers[0].pickupTime : "09:45"}',
                    key: ValueKey<bool>(viewModel.hasArrivedAtLocation),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          // Next Pickup counter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Next Pickup',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '(+${remainingPassengers.length})',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                      onPressed: () {
                        // Show info popup
                      },
                    ),
                  ],
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: viewModel.hasArrivedAtLocation
                        ? Colors.green.shade50 // Green for on time
                        : isDelayed
                            ? Colors.red.shade50 // Red for delay
                            : Colors.orange.shade50, // Orange for en route
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (isDelayed)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      Text(
                        viewModel.hasArrivedAtLocation
                            ? 'On time'
                            : isDelayed
                                ? 'Delay by 5 min'
                                : 'En route',
                        style: TextStyle(
                          color: viewModel.hasArrivedAtLocation
                              ? Colors.green.shade700
                              : isDelayed
                                  ? Colors.red.shade700
                                  : Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
            child: Divider(color: Colors.grey.shade300, height: 3),
          ),

          // Passenger card carousel
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: pageController,
              itemCount: remainingPassengers.length,
              itemBuilder: (context, index) {
                final passenger = remainingPassengers[index];
                return _buildPassengerCard(passenger, context);
              },
            ),
          ),

          // Page indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SmoothPageIndicator(
              controller: pageController,
              count: remainingPassengers.length,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: AppColors.primarycolor,
                dotColor: Colors.grey.shade300,
                spacing: 4,
              ),
            ),
          ),

          // Start Next button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.more_horiz, color: Colors.black),
                    onPressed: () {
                      _showMoreOptionsModal(context);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CommonButton(
                    label: 'Start Next',
                    onPressed: () => viewModel.startNextPickup(),
                    activeColor: AppColors.primarycolor,
                    inactiveColor: Colors.grey.shade300,
                    isActive: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerCard(Passenger passenger, BuildContext context) {
    final bool isVerified = viewModel.isPassengerOtpVerified(passenger.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 1,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with avatar, name and buttons
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 17,
                  backgroundColor: _getAvatarColor(passenger.initials),
                  child: Text(
                    passenger.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Passenger name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        passenger.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Pickup at ${passenger.pickupTime}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                // Call button
                Container(
                  height: 32,
                  width: 32,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primarycolorDark,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.call, color: Colors.white, size: 20),
                    onPressed: () {
                      // Handle call action
                    },
                  ),
                ),

                // OTP Button or Verified label
                if (isVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green.shade700,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  OutlinedButton(
                    onPressed: () {
                      // Show OTP Modal
                      _showOtpVerificationModal(context, passenger);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                      foregroundColor: AppColors.primarycolor,
                      side: BorderSide(color: AppColors.primarycolor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fixedSize: Size(SizeConfig.screenWidth * 0.25, 20),
                    ),
                    child: const Text('Enter OTP'),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10),
              child: Divider(color: Colors.grey.shade300, height: 1),
            ),

            // Address section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.primarycolor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pickup Address',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        passenger.address,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOtpVerificationModal(BuildContext context, Passenger passenger) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OtpVerificationModal(
        viewModel: viewModel,
        passenger: passenger,
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

  Widget _buildDestinationReachedBottomSheet(BuildContext context) {
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
          // Green header with destination reached message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Text(
              "You've reached your destination.",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),

          // Destination info
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Destination header
                Row(
                  children: [
                    const Text(
                      'Destination',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Text(
                            'Delay by 5 min',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Company info card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade100,
                      child: Text(
                        'SK',
                        style: TextStyle(
                          color: Colors.indigo.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    title: Text(
                      viewModel.trip.endAddress,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reach by ${viewModel.trip.endTime}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                        // Pickup Address section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.primarycolor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pickup Address',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    viewModel.trip.endAddress,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    minLeadingWidth: 0,
                  ),
                ),

             

                // End Trip button
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz, color: Colors.black),
                          onPressed: () {
                            _showMoreOptionsModal(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CommonButton(
                          label: viewModel.isLoadingAction ? 'Ending Trip...' : 'End Trip',
                          onPressed: () => viewModel.endTrip(),
                          activeColor: Colors.red,
                          inactiveColor: Colors.grey.shade300,
                          isActive: !viewModel.isLoadingAction,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
