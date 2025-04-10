class House {
  final String id;
  final String no;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String code;
  final int bedroomCount;
  final int bathroomCount;
  final bool hasBalcony;
  final String furnishingStatus;
  final String squareMeters;
  final String orientation;
  final String contactTerms;
  final String occupacy;
  final String buildingId;
  final String houseTypeId;

  House({
    required this.id,
    required this.no,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.code,
    required this.bedroomCount,
    required this.bathroomCount,
    required this.hasBalcony,
    required this.furnishingStatus,
    required this.squareMeters,
    required this.orientation,
    required this.contactTerms,
    required this.occupacy,
    required this.buildingId,
    required this.houseTypeId,
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      id: json['id'],
      no: json['no'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      code: json['code'],
      bedroomCount: json['bedroomCount'],
      bathroomCount: json['bathroomCount'],
      hasBalcony: json['hasBalcony'],
      furnishingStatus: json['furnishingStatus'],
      squareMeters: json['squareMeters'],
      orientation: json['orientation'],
      contactTerms: json['contactTerms'],
      occupacy: json['occupacy'],
      buildingId: json['buildingId'],
      houseTypeId: json['houseTypeId'],
    );
  }
}
