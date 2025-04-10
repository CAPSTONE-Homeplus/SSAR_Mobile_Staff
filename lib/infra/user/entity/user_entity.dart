class User {
  final String id;
  final String fullName;
  final String status;
  final String houseId;
  final String? extraField;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String username;
  final String role;
  final String email;
  final String phoneNumber;

  User({
    required this.id,
    required this.fullName,
    required this.status,
    required this.houseId,
    required this.extraField,
    required this.createdAt,
    required this.updatedAt,
    required this.username,
    required this.role,
    required this.email,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      status: json['status'],
      houseId: json['houseId'],
      extraField: json['extraField'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      username: json['username'],
      role: json['role'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
