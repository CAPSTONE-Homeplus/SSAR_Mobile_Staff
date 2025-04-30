class StaffStatus {
  final String id;
  final String status; // "Offline" hoặc "Ready"
  final DateTime lastUpdated;
  final String fullName;
  final String phoneNumber;

  StaffStatus({
    required this.id,
    required this.status,
    required this.lastUpdated,
    required this.fullName,
    required this.phoneNumber,
  });

  factory StaffStatus.fromJson(Map<String, dynamic> json) => StaffStatus(
        id: json['id'],
        status: json['status'],
        lastUpdated: DateTime.parse(json['lastUpdated']),
        fullName: json['fullName'],
        phoneNumber: json['phoneNumber'],
      );
}
