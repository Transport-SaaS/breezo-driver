class Address {
  final int iid;
  final String addressText;
  final double lat;
  final double lng;
  final String? pinCode;
  final String addressName;
  final String? landmark;
  final String? city;
  bool active;

  Address({
    required this.iid,
    required this.addressText,
    required this.lat,
    required this.lng,
    this.pinCode,
    required this.addressName,
    this.landmark,
    this.city,
    required this.active,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    // Ensure iid is parsed as an integer
    int iid;
    if (json['iid'] is int) {
      iid = json['iid'];
    } else if (json['iid'] is String) {
      iid = int.tryParse(json['iid']) ?? 0;
    } else {
      iid = 0;
    }
    
    return Address(
      iid: iid,
      addressText: json['addressText'] ?? '',
      lat: (json['lat'] is num) ? (json['lat'] as num).toDouble() : 0.0,
      lng: (json['lng'] is num) ? (json['lng'] as num).toDouble() : 0.0,
      pinCode: json['pinCode'],
      addressName: json['addressName'] ?? '',
      landmark: json['landmark'],
      city: json['city'],
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iid': iid,
      'addressText': addressText,
      'lat': lat,
      'lng': lng,
      'pinCode': pinCode,
      'addressName': addressName,
      'landmark': landmark,
      'city': city,
      'active': active,
    };
  }

  // Helper method to get a display name for the address
  String get displayName {
    if (addressName.isNotEmpty) {
      return addressName;
    } else {
      return addressText.length > 30 
          ? '${addressText.substring(0, 30)}...' 
          : addressText;
    }
  }

  // Create a copy of this address with some fields replaced
  Address copyWith({
    int? iid,
    String? addressText,
    double? lat,
    double? lng,
    String? pinCode,
    String? addressName,
    String? landmark,
    String? city,
    bool? active,
  }) {
    return Address(
      iid: iid ?? this.iid,
      addressText: addressText ?? this.addressText,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      pinCode: pinCode ?? this.pinCode,
      addressName: addressName ?? this.addressName,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      active: active ?? this.active,
    );
  }
}