
class TripStep {
  final String address;
  final String addressName;
  final String name;
  final int id;
  final int arrival;
  final int duration;
  final List<int> load;
  final List<double> location;
  final int service;
  final int setup;
  final String type;
  // final List<dynamic> violations;
  final int waitingTime;
  final String stepType;

  TripStep({
    required this.address,
    required this.addressName,
    required this.name,
    required this.id,
    required this.arrival,
    required this.duration,
    required this.load,
    required this.location,
    required this.service,
    required this.setup,
    required this.type,
    // required this.violations,
    required this.waitingTime,
    required this.stepType,
  });

  factory TripStep.fromJson(Map<String, dynamic> json) {
    return TripStep(
      address: json['address'] ?? '',
      addressName: json['addressName'] ?? '',
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
      arrival: json['arrival'] ?? 0,
      duration: json['duration'] ?? 0,
      load: List<int>.from(json['load']),
      location: List<double>.from(json['location']),
      service: json['service'] ?? 0,
      setup: json['setup'] ?? 0,
      type: json['type'] ?? '',
      // violations: json['violations'],
      waitingTime: json['waiting_time'] ?? 0,
      stepType: json['stepType'] ?? '',
    );
  }
}
