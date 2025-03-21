import 'package:equatable/equatable.dart';

class StaffOrder extends Equatable {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String gender;
  final DateTime dateOfBirth;
  final String address;
  final DateTime hireDate;
  final String jobPosition;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String accountId;
  final String groupId;
  final String code;

  const StaffOrder({
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

  factory StaffOrder.fromJson(Map<String, dynamic> json) {
    return StaffOrder(
      id: json["id"],
      fullName: json["fullName"],
      phoneNumber: json["phoneNumber"],
      email: json["email"],
      gender: json["gender"],
      dateOfBirth: DateTime.parse(json["dateOfBirth"]),
      address: json["address"],
      hireDate: DateTime.parse(json["hireDate"]),
      jobPosition: json["jobPosition"],
      status: json["status"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      accountId: json["accountId"],
      groupId: json["groupId"],
      code: json["code"],
    );
  }

  @override
  List<Object?> get props => [id, fullName, phoneNumber, email, jobPosition];
}
