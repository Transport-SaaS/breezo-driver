import 'package:flutter/material.dart';
import 'package:breezodriver/features/trips/models/trip_model.dart';

class TripRatingViewModel extends ChangeNotifier {
  final TripModel trip;
  
  double _overallRating = 5.0;
  final Map<String, double> _passengerRatings = {};
  String? _selectedIssue;
  String? _additionalComments;
  bool _isSubmittingFeedback = false;
  
  TripRatingViewModel(this.trip) {
    // Initialize default ratings for all passengers
    for (final passenger in trip.passengerList) {
      _passengerRatings[passenger.id] = 5.0;
    }
  }
  
  // Getters
  double get overallRating => _overallRating;
  Map<String, double> get passengerRatings => _passengerRatings;
  String? get selectedIssue => _selectedIssue;
  String? get additionalComments => _additionalComments;
  bool get isSubmittingFeedback => _isSubmittingFeedback;
  
  // Setters
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
  
  Future<bool> submitFeedback() async {
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
    
    return true; // Return success
  }
} 