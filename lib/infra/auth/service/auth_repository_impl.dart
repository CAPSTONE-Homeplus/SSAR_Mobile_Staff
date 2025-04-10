import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/http/dio_http_service.dart';
import 'package:home_staff/infra/http/http_service.dart';
import 'package:home_staff/infra/storage/hive_storage_service.dart';
import 'package:home_staff/infra/storage/storage_service.dart';
import 'package:logger/logger.dart';

import '../entity/auth_entity.dart';
import '../entity/user_entity.dart';
import 'auth_exception.dart';
import 'auth_repository.dart';
import 'request/login_request.dart';
import 'request/logout_request.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final httpService = ref.watch(httpServiceProvider);
  final storage = ref.watch(localStorageServiceProvider);
  return AuthRepositoryImpl(httpService, storage);
});

final authStateProvider = StateProvider<AuthEntity?>((ref) => null);

class AuthRepositoryImpl implements AuthRepository {
  final HttpService http;
  final StorageService storage;
  final Logger logger = Logger();
  AuthRepositoryImpl(this.http, this.storage);

  @override
  Future<AuthEntity> login(UserEntity user) async {
    try {
      final response = await http.request(
        LoginRequest(user: user),
        transformer: (data) => data,
      );
      await storage.setObject<Map<String, dynamic>>(
        key: 'user',
        data: response,
      );

      return AuthEntity.fromJson(response);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 400) {
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
      await http.request(
        LogoutRequest(),
        transformer: (_) => null,
      );

      await storage.deleteValue('user');
    } catch (e) {
      throw AuthException("Đăng xuất thất bại");
    }
  }

  Future<Map<String, dynamic>?> getStoredAuthData() async {
    return storage.getObject<Map<String, dynamic>>(
      'user',
      (json) => json,
    );
  }
}
