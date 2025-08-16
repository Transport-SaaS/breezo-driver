import 'dart:async';
import 'package:flutter/material.dart';
import 'package:breezodriver/features/trips/models/trip_model.dart';

enum TripStatus {
  assigned,
  accepted,
  readyToStart,
  inProgress,
  destinationReached,
  completed,
  cancelled
}

class TripDetailsViewModel extends ChangeNotifier {
  final TripModel _trip;
  TripStatus _status = TripStatus.assigned;
  Timer? _delayTimer;
  Timer? _arrivalTimer;
  int _delaySeconds = 5; // Initial 5-second timer
  bool _isLoadingAction = false;
  bool _canStartTrip = false;
  bool _hasArrivedAtLocation = false;
  
  // Track which passengers have been picked up
  final Set<String> _pickedUpPassengerIds = {};
  
  // Track OTP verification status for each passenger
  final Map<String, bool> _passengerOtpVerified = {};
  
  // Current passenger index in pickup flow
  int _currentPassengerIndex = 0;
  
  // Track OTP input/verification state
  bool _isVerifyingOtp = false;
  
  // Arrival timer countdown (1 minute = 60 seconds)
  int _arrivalSeconds = 60;
  
  // Separate timer for Getting Ready state
  static const int initialAssignedDelay = 5; // 5 seconds for assigned state
  static const int initialAcceptedDelay = 10; // 10 seconds for accepted state

  // Arrival notification - visible briefly when the driver arrives
  bool _showArrivedNotification = false;
  
  // Rating-related properties
  double _overallRating = 0;
  final Map<String, double> _passengerRatings = {};
  String? _selectedIssue;
  String? _additionalComments;
  bool _isSubmittingFeedback = false;
  
  // For rejection reason
  String? _rejectionReason;
  TripDetailsViewModel(this._trip) {
    // Initialize timer if trip is assigned
    if (_trip.status == 'Assigned') {
      _delaySeconds = initialAssignedDelay;
      _startDelayTimer();
    } else if (_trip.status == 'Accepted') {
      _status = TripStatus.accepted;
      _delaySeconds = 0;
      _canStartTrip = true;
    } else if (_trip.status == 'Completed') {
      _status = TripStatus.completed;
      _delaySeconds = 0;
      _canStartTrip = false;
    }
  }

  TripModel get trip => _trip;
  TripStatus get status => _status;
  int get delaySeconds => _delaySeconds;
  bool get isLoadingAction => _isLoadingAction;
  bool get canStartTrip => _canStartTrip;
  Set<String> get pickedUpPassengerIds => _pickedUpPassengerIds;
  int get currentPassengerIndex => _currentPassengerIndex;
  bool get isVerifyingOtp => _isVerifyingOtp;
  bool get hasArrivedAtLocation => _hasArrivedAtLocation;
  int get arrivalSeconds => _arrivalSeconds;
  bool get showArrivedNotification => _showArrivedNotification;
  
  // Rating getters
  double get overallRating => _overallRating;
  Map<String, double> get passengerRatings => _passengerRatings;
  String? get selectedIssue => _selectedIssue;
  String? get additionalComments => _additionalComments;
  bool get isSubmittingFeedback => _isSubmittingFeedback;
  
  // Getter for rejection reason
  String? get rejectionReason => _rejectionReason;
  
  String get formattedDelay {
    int minutes = _delaySeconds ~/ 60;
    int seconds = _delaySeconds % 60;
    
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    
    return '$minutesStr:$secondsStr';
  }
  
  String get formattedArrivalTime {
    int minutes = _arrivalSeconds ~/ 60;
    int seconds = _arrivalSeconds % 60;
    
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    
    return '$minutesStr:$secondsStr';
  }

  void _startDelayTimer() {
    _delayTimer?.cancel();
    _delayTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_delaySeconds > 0) {
        _delaySeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        // If timer completes in accepted state, enable Start Trip button
        if (_status == TripStatus.accepted) {
          _canStartTrip = true;
          _status = TripStatus.readyToStart;
          notifyListeners();
        }
      }
    });
  }
  
  void _startArrivalTimer() {
    _arrivalTimer?.cancel();
    _arrivalSeconds = 60; // Reset to 1 minute
    _hasArrivedAtLocation = false;
    _showArrivedNotification = false;
    
    _arrivalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_arrivalSeconds > 0) {
        _arrivalSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        // Driver has arrived at location
        _hasArrivedAtLocation = true;
        _showArrivedNotification = true;
        notifyListeners();
        
        // Hide the arrival notification after 3 seconds
        Timer(const Duration(seconds: 3), () {
          if (_showArrivedNotification) {
            _showArrivedNotification = false;
            notifyListeners();
          }
        });
      }
    });
  }

  Future<void> acceptTrip() async {
    _isLoadingAction = true;
    notifyListeners();
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Move to accepted state and start a new 10-second timer
    _status = TripStatus.accepted;
    _delayTimer?.cancel();
    _delaySeconds = initialAcceptedDelay;
    _canStartTrip = false; // Can't start trip until timer completes
    _isLoadingAction = false;
    
    // Start the Getting Ready timer
    _startDelayTimer();
    
    notifyListeners();
  }
  
  Future<void> rejectTrip() async {
    _isLoadingAction = true;
    notifyListeners();
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Log the rejection reason
    if (_rejectionReason != null) {
      print('Trip rejected for reason: $_rejectionReason');
    }
    
    _status = TripStatus.cancelled;
    _delayTimer?.cancel();
    _isLoadingAction = false;
    notifyListeners();
  }
  
  Future<void> startTrip() async {
    // Only allow starting trip if the Getting Ready timer has completed
    if (!_canStartTrip) return;
    
    _isLoadingAction = true;
    notifyListeners();
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    _status = TripStatus.inProgress;
    _isLoadingAction = false;
    
    // Start the arrival timer for the first passenger
    _startArrivalTimer();
    
    notifyListeners();
  }
  
  Future<void> startNextPickup() async {
    _isLoadingAction = true;
    notifyListeners();
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mark current passenger as picked up
    if (_currentPassengerIndex < _trip.passengerList.length) {
      final currentPassenger = _trip.passengerList[_currentPassengerIndex];
      _pickedUpPassengerIds.add(currentPassenger.id);
      
      // Move to next passenger
      _currentPassengerIndex++;
      
      // If all passengers are picked up, move to destination reached state
      if (_currentPassengerIndex >= _trip.passengerList.length) {
        // Move to destination reached state
        await reachDestination();
      } else {
        // Start arrival timer for next passenger
        _startArrivalTimer();
      }
    }
    
    _isLoadingAction = false;
    notifyListeners();
  }
  
  // OTP Verification Methods
  bool isPassengerOtpVerified(String passengerId) {
    return _passengerOtpVerified[passengerId] ?? false;
  }
  
  void setVerifyingOtp(bool isVerifying) {
    _isVerifyingOtp = isVerifying;
    notifyListeners();
  }
  
  Future<bool> verifyOtp(String passengerId, String otp) async {
    // In a real app, this would make an API call to verify the OTP
    // For this simulation, we'll just accept any 4-digit OTP
    _isLoadingAction = true;
    notifyListeners();
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Mark passenger as verified if OTP has 4 digits
    bool isValid = otp.length == 4;
    if (isValid) {
      _passengerOtpVerified[passengerId] = true;
    }
    
    _isLoadingAction = false;
    notifyListeners();
    
    return isValid;
  }

  // For demonstration purposes - manually trigger arrival
  void simulateArrival() {
    if (!_hasArrivedAtLocation) {
      _arrivalTimer?.cancel();
      _hasArrivedAtLocation = true;
      _showArrivedNotification = true;
      notifyListeners();
      
      // Hide the arrival notification after 3 seconds
      Timer(const Duration(seconds: 3), () {
        if (_showArrivedNotification) {
          _showArrivedNotification = false;
          notifyListeners();
        }
      });
    }
  }
  
  // For demonstration purposes - manually reset arrival state
  void resetArrivalState() {
    if (_hasArrivedAtLocation) {
      _hasArrivedAtLocation = false;
      _showArrivedNotification = false;
      _startArrivalTimer(); // Restart the timer
      notifyListeners();
    }
  }

  // Update trip to destination reached state
  Future<void> reachDestination() async {
    _isLoadingAction = true;
    notifyListeners();
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    _status = TripStatus.destinationReached;
    _isLoadingAction = false;
    notifyListeners();
  }
  
  // End the trip and move to rating screen
  Future<void> endTrip() async {
    _isLoadingAction = true;
    notifyListeners();
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    _status = TripStatus.completed;
    _isLoadingAction = false;
    
    // Don't trigger UI updates that would cause navigation loops
    // The navigation to rating screen should be handled externally,
    // not through status change notification
    notifyListeners();
  }
  
  // Rating methods
  void setOverallRating(double rating) {
    _overallRating = rating;
    notifyListeners();
  }
  
  void setPassengerRating(String passengerId, double rating) {
    _passengerRatings[passengerId] = rating;
    notifyListeners();
  }
  
  void setSelectedIssue(String issue) {
    _selectedIssue = issue;
    notifyListeners();
  }
  
  void setAdditionalComments(String comments) {
    _additionalComments = comments;
    notifyListeners();
  }
  
  Future<void> submitFeedback() async {
    _isSubmittingFeedback = true;
    notifyListeners();
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // In a real app, this would send the rating data to a backend
    print('Overall rating: $_overallRating');
    print('Passenger ratings: $_passengerRatings');
    print('Selected issue: $_selectedIssue');
    print('Additional comments: $_additionalComments');
    
    _isSubmittingFeedback = false;
    notifyListeners();
  }
  
  // For demonstration purposes - simulate completion of all passenger pickups
  void simulateAllPickupsComplete() {
    // Mark all passengers as picked up
    for (final passenger in _trip.passengerList) {
      _pickedUpPassengerIds.add(passenger.id);
      // Also mark them as verified for testing purposes
      _passengerOtpVerified[passenger.id] = true;
    }
    
    // Update the current passenger index
    _currentPassengerIndex = _trip.passengerList.length;
    
    // Move to destination reached state
    reachDestination();
  }

  // Setter for rejection reason
  void setRejectionReason(String reason) {
    _rejectionReason = reason;
    notifyListeners();
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _arrivalTimer?.cancel();
    super.dispose();
  }
} 