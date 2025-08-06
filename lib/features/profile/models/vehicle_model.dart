// <result property="registrationNo" column="registration_no"/>
// <result property="vehicleType" column="vehicle_type"/>
// <result property="colour" column="colour"/>
// <result property="manufacturerName" column="manufacturer_name"/>
// <result property="brandName" column="brand_name"/>
// <result property="seatingCapacity" column="seating_capacity"


class Vehicle {
  final String registrationNo;
  final String vehicleType; // e.g., Car, Bike, Truck
  final String colour;
  final String manufacturerName;
  final String brandName;
  final int seatingCapacity;

  Vehicle({
    required this.registrationNo,
    required this.vehicleType,
    required this.colour,
    required this.manufacturerName,
    required this.brandName,
    required this.seatingCapacity,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      registrationNo: json['registrationNo'],
      vehicleType: json['vehicleType'],
      colour: json['colour'],
      manufacturerName: json['manufacturerName'],
      brandName: json['brandName'],
      seatingCapacity: json['seatingCapacity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registration_no': registrationNo,
      'vehicle_type': vehicleType,
      'colour': colour,
      'manufacturer_name': manufacturerName,
      'brand_name': brandName,
      'seating_capacity': seatingCapacity,
    };
  }
}