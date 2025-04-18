class TripSchedule {
  final DateTime date;
  final List<Trip> trips;

  TripSchedule({required this.date, required this.trips});

  factory TripSchedule.fromJson(Map<String, dynamic> json) {
    return TripSchedule(
      date: DateTime.parse(json['date']),
      trips: (json['trips'] as List).map((e) => Trip.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'trips': trips.map((e) => e.toJson()).toList(),
    };
  }
}

class Trip {
  final String time;
  final String location;
  final String address;
  final bool isScheduled; 
  final bool isCompleted;
  final String type; // Home or Office
  final Duration lockDuration; // Time remaining before locking

  Trip({
    required this.time,
    required this.location,
    required this.address,
    required this.type,
    required this.lockDuration,
    required this.isCompleted,
    required this.isScheduled,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      time: json['time'],
      location: json['location'],
      address: json['address'],
      type: json['type'],
      lockDuration: Duration(minutes: json['lockDuration']),
      isScheduled: json['isScheduled'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'location': location,
      'address': address,
      'type': type,
      'lockDuration': lockDuration.inMinutes,
      'isScheduled': isScheduled,
      'isCompleted': isCompleted,
    };
  }
}
