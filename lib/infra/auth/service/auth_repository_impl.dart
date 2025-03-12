import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/constants.dart';
import '../entity/user_entity.dart';
import '../entity/auth_entity.dart';
import '../service/auth_exception.dart';
import 'auth_repository.dart';

// Provider quản lý Dio Client
final dioProvider = Provider<Dio>((ref) => Dio());

// Provider quản lý AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepositoryImpl(dio);
});

// Provider quản lý trạng thái đăng nhập
final authStateProvider = StateProvider<AuthEntity?>((ref) => null);

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  static const String baseApiUrl = AppConstants.baseApiUrl;

  AuthRepositoryImpl(this.dio);

  @override
  Future<AuthEntity> login(UserEntity user) async {
    try {
      final response = await dio.post(
        "$baseApiUrl/auth/login-staff",
        data: {
          "phoneNumber": user.phoneNumber,
          "password": user.password,
        },
      );

      if (response.statusCode == 200) {
        return AuthEntity.fromJson(response.data);
      } else {
        throw AuthException("Đăng nhập thất bại");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errorMessage = e.response?.data["description"] ?? "Đăng nhập thất bại";
        throw AuthException(errorMessage); // Gửi lỗi từ backend
      }
      throw AuthException("Lỗi không xác định. Vui lòng thử lại.");
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post("$baseApiUrl/auth/logout");
    } on DioException {
      throw AuthException("Đăng xuất thất bại");
    }
  }
}
