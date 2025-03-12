import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String phoneNumber;
  final String password;

  UserEntity({
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [phoneNumber, password];
}