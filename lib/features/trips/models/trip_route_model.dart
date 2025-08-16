import 'package:breezodriver/features/trips/models/trip_step_model.dart';

class TripRouteModel {
  final List<int> mAmount;
  final int mCost;
  final List<int> mDelivery;
  final int mDuration;
  final List<int> mPickup;
  final int mPriority;
  final int mService;
  final int mSetup;
  final List<TripStep> mSteps;
  final int mVehicle;
  // final List<String> mViolations;
  final int mWaitingTime;

  TripRouteModel({
    required this.mAmount,
    required this.mCost,
    required this.mDelivery,
    required this.mDuration,
    required this.mPickup,
    required this.mPriority,
    required this.mService,
    required this.mSetup,
    required this.mSteps,
    required this.mVehicle,
    // required this.mViolations,
    required this.mWaitingTime,
  });

  factory TripRouteModel.fromJson(Map<String, dynamic> json) {
    return TripRouteModel(
      mAmount: (json['amount'] as List<dynamic>?)?.cast<int>() ?? [],
      mCost: json['cost'] ?? 0,
      mDelivery: (json['delivery'] as List<dynamic>?)?.cast<int>() ?? [],
      mDuration: json['duration'] ?? 0,
      mPickup: (json['pickup'] as List<dynamic>?)?.cast<int>() ?? [],
      mPriority: json['priority'] ?? 0,
      mService: json['service'] ?? 0,
      mSetup: json['setup'] ?? 0,
      mSteps: (json['steps'] as List<dynamic>?)
          ?.map((step) => TripStep.fromJson(step))
          .toList() ??
          [],
      mVehicle: json['vehicle'] ?? 0,
      // mViolations = (json['violations'] as List<dynamic>?)?.cast<String>() ?? [],
      mWaitingTime: json['waiting_time'] ?? ''
    );
    // mAmount = (json['amount'] as List<dynamic>?)?.cast<int>() ?? [],
    // mCost = json['cost'] ?? '',
    // mDelivery = (json['delivery'] as List<dynamic>?)?.cast<int>() ?? [],
    // mDuration = json['duration'] ?? '',
    // mPickup = (json['pickup'] as List<dynamic>?)?.cast<int>() ?? [],
    // mPriority = json['priority'] ?? '',
    // mService = json['service'] ?? '',
    // mSetup = json['setup'] ?? '',
    // mSteps = (json['steps'] as List<dynamic>?)
    //     ?.map((step) => TripStep.fromJson(step))
    //     .toList() ??
    // [],
    // mVehicle = json['vehicle'] ?? '',
    // // mViolations =
    // //     (json['violations'] as List<dynamic>?)?.cast<String>() ?? [],
    // mWaitingTime = json['waiting_time'] ?? '';
  }

  TripRouteModel.empty()
      : mAmount = [],
        mCost = 0,
        mDelivery = [],
        mDuration = 0,
        mPickup = [],
        mPriority = 0,
        mService = 0,
        mSetup = 0,
        mSteps = [],
        mVehicle = 0,
        // mViolations = [],
        mWaitingTime = 0;
}