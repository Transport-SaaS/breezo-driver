import 'package:breezodriver/features/trips/models/trip_step_model.dart';
import 'package:flutter/material.dart';

class TripModel {
  final String id;
  final DateTime assignedAt;
  final DateTime startTime;
  final List<double> startLocation;
  final String startAddress;
  final DateTime endTime;
  final List<double> endLocation;
  final String endAddress;
  final String duration;
  final String distance;
  late final int passengers;
  final String status; // "Assigned", "Accepted", "Missed", "Completed"
  final String acceptBeforeTime;
  final List<Passenger> passengerList;
  final bool? isToBase;

  TripModel({
    required this.id,
    required this.assignedAt,
    required this.startTime,
    required this.startLocation,
    required this.startAddress,
    required this.endTime,
    required this.endLocation,
    required this.endAddress,
    required this.duration,
    required this.distance,
    required this.passengers,
    required this.status,
    required this.acceptBeforeTime,
    required this.passengerList,
    this.isToBase,
  });

  static TripModel fromBackendJson(Map<String, dynamic> json) {
    // This method is used to create a TripModel instance from backend JSON data
    /*
    {
		"iid": 8,
		"vehicle_iid": 1,
		"driver_iid": 1,
		"trip_start_timestamp": "2025-08-07T11:51:46.000+00:00",
		"trip_end_timestamp": "2025-08-07T13:11:46.000+00:00",
		"is_to_base": true,
		"startStep": {
			"address": "abc, 123 lane",
			"addressName": "M2",
			"name": "M2",
			"id": 1,
			"arrival": 1708519800,
			"duration": 1994,
			"load": [
				3
			],
			"location": [
				78.37972153214963,
				17.44105782846675
			],
			"service": 600,
			"setup": 0,
			"type": "pickup",
			"violations": [],
			"waiting_time": 0,
			"stepType": "office"
		},
		"endStep": {
			"address": "123, house, street",
			"name": "TransporterOff",
			"arrival": 1708523218,
			"duration": 5832,
			"load": [
				0
			],
			"location": [
				78.36472261933835,
				17.529227138321993
			],
			"service": 0,
			"setup": 0,
			"type": "end",
			"violations": [],
			"waiting_time": 0,
			"stepType": "home"
		}
	}
     */
    return TripModel(
      id: json['iid'].toString(),
      assignedAt: DateTime.parse(json['trip_start_timestamp']),
      startTime: DateTime.parse(json['trip_start_timestamp']),
      startLocation: json['startStep']['location'] != null
          ? [json['startStep']['location'][0], json['startStep']['location'][1]]
          : [0.0, 0.0],
      startAddress: json['startStep']['address'] ?? '',
      endTime: DateTime.parse(json['trip_end_timestamp']),
      endLocation: json['endStep']['location'] != null
          ? [json['endStep']['location'][0], json['endStep']['location'][1]]
          : [0.0, 0.0],
      endAddress: json['endStep']['address'] ?? '',
      duration: (json['endStep']['arrival'] - json['startStep']['arrival'])
          .toString(),
      distance: '', // Assuming distance is not provided in the JSON
      passengers: 0, // Assuming no passengers data in the JSON
      status: json['driverTripStatus'], // Default status, can be updated later
      acceptBeforeTime: '', // Assuming no accept before time in the JSON
      passengerList: [], // Assuming no passenger list in the JSON
      isToBase: json['is_to_base'] ?? false,
    );
  }

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] ?? '',
      assignedAt: DateTime.parse(json['assignedAt']),
      startTime: DateTime.parse(json['startTime']),
      startLocation: json['startLocation'] ?? '',
      startAddress: json['startAddress'] ?? '',
      endTime: DateTime.parse(json['endTime']),
      endLocation: json['endLocation'] ?? '',
      endAddress: json['endAddress'] ?? '',
      duration: json['duration'] ?? '',
      distance: json['distance'] ?? '',
      passengers: json['passengers'] ?? 0,
      status: json['status'] ?? 'Assigned',
      acceptBeforeTime: json['acceptBeforeTime'] ?? '',
      passengerList: (json['passengerList'] as List?)
          ?.map((p) => Passenger.fromJson(p))
          .toList() ?? [],
      isToBase: json['isToBase'] ?? false, // Assuming isToBase is a boolean
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignedAt': assignedAt,
      'startTime': startTime,
      'startLocation': startLocation,
      'startAddress': startAddress,
      'endTime': endTime,
      'endLocation': endLocation,
      'endAddress': endAddress,
      'duration': duration,
      'distance': distance,
      'passengers': passengers,
      'status': status,
      'acceptBeforeTime': acceptBeforeTime,
      'passengerList': passengerList.map((p) => p.toJson()).toList(),
      'isToBase': isToBase ?? false, // Assuming isToBase is a boolean
    };
  }
}

class Passenger {
  final String id;
  final String name;
  final String address;
  final String pickupTime;
  final String? profileImage;
  final String initials;
  final List<double> location;

  Passenger({
    required this.id,
    required this.name,
    required this.address,
    required this.pickupTime,
    this.profileImage,
    required this.initials,
    required this.location
  });

  static Passenger fromTripStep(TripStep stop) {
    // This method is used to create a Passenger instance from a TripStop
    DateTime arrivalTime = DateTime.fromMillisecondsSinceEpoch(stop.arrival*1000);
    return Passenger(
      id: stop.id.toString(),
      name: stop.name,
      address: stop.address,
      pickupTime: '${arrivalTime.hour}:${arrivalTime.minute.toString().padLeft(2, '0')}', // Format as HH:mm
      profileImage: null, // Assuming no profile image in TripStop
      initials: _getInitials(stop.name),
      location: stop.location.isNotEmpty
          ? [stop.location[0], stop.location[1]]
          : [0.0, 0.0],
    );
  }
  static String _getInitials(String name) {
    // This method generates initials from the passenger's name
    List<String> parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0].toUpperCase()}${parts[1][0].toUpperCase()}';
    } else {
      return parts[0][0].toUpperCase();
    }
  }
  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      pickupTime: json['pickupTime'] ?? '',
      profileImage: json['profileImage'],
      initials: json['initials'] ?? '',
      location: json['endLocation'] != null
          ? [json['endLocation'][0], json['endLocation'][1]]
          : [0.0, 0.0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'pickupTime': pickupTime,
      'profileImage': profileImage,
      'initials': initials,
      'endLocation': location.isNotEmpty
          ? [location[0], location[1]]
          : [0.0, 0.0],
    };
  }
}