import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String fullName;
  final String status;
  final String role;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.fullName,
    required this.status,
    required this.role,
  });

  factory AuthEntity.fromJson(Map<String, dynamic> json) {
    return AuthEntity(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
      fullName: json['fullName'],
      status: json['status'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userId': userId,
      'fullName': fullName,
      'status': status,
      'role': role,
    };
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, userId, fullName, status, role];
}
