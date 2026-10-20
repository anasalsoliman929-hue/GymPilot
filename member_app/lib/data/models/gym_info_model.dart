class GymInfoModel {
  final String name;
  final String? address;
  final String? phone;
  final int? minAge;
  final String? logoUrl;

  GymInfoModel({
    required this.name,
    this.address,
    this.phone,
    this.minAge,
    this.logoUrl,
  });

  factory GymInfoModel.fromJson(Map<String, dynamic> json) {
    return GymInfoModel(
      name:    json['name']?.toString() ?? '',
      address: json['address']?.toString(),
      phone:   json['phone']?.toString(),
      minAge:  json['min_age'] as int?,
      logoUrl: json['logo_url']?.toString(),
    );
  }
}
