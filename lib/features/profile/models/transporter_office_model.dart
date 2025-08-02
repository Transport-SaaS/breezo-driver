class TransporterOfficeModel {
  final String transporterName;
  final String officeName;
  final String officeAddress;

  TransporterOfficeModel({
    required this.transporterName,
    required this.officeName,
    required this.officeAddress
  });

  factory TransporterOfficeModel.fromJson(Map<String, dynamic> json) {
    return TransporterOfficeModel(
      transporterName: json['transporterName'] ?? '',
      officeName: json['officeName'] ?? '',
      officeAddress: json['officeAddress'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transporterName': transporterName,
      'officeName': officeName,
      'officeAddress': officeAddress
    };
  }
}
