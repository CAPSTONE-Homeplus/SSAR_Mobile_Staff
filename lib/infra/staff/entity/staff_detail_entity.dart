class StaffDetail {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String gender;
  final String dateOfBirth;
  final String address;
  final String hireDate;
  final String jobPosition;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? accountId;
  final String groupId;
  final String code;

  StaffDetail({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
    required this.hireDate,
    required this.jobPosition,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.accountId,
    required this.groupId,
    required this.code,
  });

  factory StaffDetail.fromJson(Map<String, dynamic> json) => StaffDetail(
        id: json['id'],
        fullName: json['fullName'],
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        gender: json['gender'],
        dateOfBirth: json['dateOfBirth'],
        address: json['address'],
        hireDate: json['hireDate'],
        jobPosition: json['jobPosition'],
        status: json['status'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        accountId: json['accountId'],
        groupId: json['groupId'],
        code: json['code'],
      );
}
