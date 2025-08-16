import 'package:breezodriver/features/trips/models/trip_model.dart';
import 'package:breezodriver/features/trips/models/trip_route_model.dart';
import 'package:flutter/material.dart';

import '../../../core/services/service_locator.dart';
import '../repositories/trip_repository.dart';

class TripViewModel extends ChangeNotifier {
  final TripRepository _tripRepository = serviceLocator<TripRepository>();

  List<TripModel> _plannedTrips = [];
  List<TripModel> get plannedTrips => _plannedTrips;
  List<TripModel> _pastTrips = [];
  List<TripModel> get pastTrips => _pastTrips;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadPlannedTrips() async {
    _isLoading = true;
    notifyListeners();

    try {
      _plannedTrips = await _tripRepository.getPlannedTrips();
    } catch (e) {
      print('Error loading planned trips: $e');
      _plannedTrips = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPastTrips() async {
    _isLoading = true;
    notifyListeners();

    try {
      _pastTrips = await _tripRepository.getPastTrips();
    } catch (e) {
      print('Error loading past trips: $e');
      _pastTrips = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTripDetails(TripModel trip, bool isPastTrip) async {
    _isLoading = true;
    notifyListeners();
    if(trip.passengerList.isNotEmpty) {
      return;
    }
    try {
      TripRouteModel tripRoute = await _tripRepository.getTripRoute(int.parse(trip.id), isPastTrip);
      for( var step in tripRoute.mSteps) {
        if(step.type=='pickup' || step.type=='delivery') {
          if(trip.isToBase==true && step.type == 'delivery') {
            trip.passengerList.add(Passenger.fromTripStep(step));
          }
          else if(trip.isToBase == false && step.type == 'pickup') {
            trip.passengerList.add(Passenger.fromTripStep(step));
          }
        }
      }
      trip.passengers = trip.passengerList.length;
      // Handle the trip details as needed
    } catch (e) {
      print('Error loading trip details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}