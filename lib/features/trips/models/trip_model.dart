import 'package:flutter/material.dart';

class TripModel {
  final String id;
  final String assignedAt;
  final String startTime;
  final String startLocation;
  final String startAddress;
  final String endTime;
  final String endLocation;
  final String endAddress;
  final String duration;
  final String distance;
  final int passengers;
  final String status; // "Assigned", "Accepted", "Missed", "Completed"
  final String acceptBeforeTime;
  final List<Passenger> passengerList;

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
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] ?? '',
      assignedAt: json['assignedAt'] ?? '',
      startTime: json['startTime'] ?? '',
      startLocation: json['startLocation'] ?? '',
      startAddress: json['startAddress'] ?? '',
      endTime: json['endTime'] ?? '',
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

  Passenger({
    required this.id,
    required this.name,
    required this.address,
    required this.pickupTime,
    this.profileImage,
    required this.initials,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      pickupTime: json['pickupTime'] ?? '',
      profileImage: json['profileImage'],
      initials: json['initials'] ?? '',
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
    };
  }
}