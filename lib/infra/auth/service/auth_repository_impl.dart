import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/storage/hive_storage_service.dart';
import 'package:home_staff/infra/storage/storage_service.dart';

import '../../../constants/constants.dart';
import '../entity/auth_entity.dart';
import '../entity/user_entity.dart';
import '../service/auth_exception.dart';
import 'auth_repository.dart';

// Provider quản lý Dio Client
final dioProvider = Provider<Dio>((ref) => Dio());

// Provider quản lý AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(localStorageServiceProvider);
  return AuthRepositoryImpl(dio, storage);
});

// Provider quản lý trạng thái đăng nhập
final authStateProvider = StateProvider<AuthEntity?>((ref) => null);

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final StorageService storage;
  static const String baseApiUrl = AppConstants.baseApiUrl;

  AuthRepositoryImpl(this.dio, this.storage);

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
        // Lưu toàn bộ response.data vào Hive
        await storage.setObject<Map<String, dynamic>>(
          key: 'user',
          data: response.data,
        );

        return AuthEntity.fromJson(response.data);
      } else {
        throw AuthException("Đăng nhập thất bại");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errorMessage =
            e.response?.data["description"] ?? "Đăng nhập thất bại";
        throw AuthException(errorMessage);
      }
      throw AuthException("Lỗi không xác định. Vui lòng thử lại.");
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post("$baseApiUrl/auth/logout");

      // Xóa dữ liệu đăng nhập khỏi Hive
      await storage.deleteValue('auth_data');
    } on DioException {
      throw AuthException("Đăng xuất thất bại");
    }
  }

  /// Lấy dữ liệu đăng nhập đã lưu trong Hive
  Future<Map<String, dynamic>?> getStoredAuthData() async {
    return storage.getObject<Map<String, dynamic>>(
      'auth_data',
      (json) => json,
    );
  }
}
