import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/features/home/controller/home_controller.dart';
import 'package:home_staff/helpers/base_paginated_response.dart';
import 'package:home_staff/infra/staff/entity/staff_order_entity.dart';
import 'package:home_staff/infra/staff/service/staff_repository.dart';
import 'package:home_staff/infra/storage/hive_storage_service.dart';
import 'package:home_staff/infra/storage/storage_service.dart';

import '../../../constants/constants.dart';
import '../service/staff_exception.dart';

// Provider quản lý Dio Client
final dioProvider = Provider<Dio>((ref) => Dio());

// Provider quản lý StaffRepository
final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final storageService = ref.watch(localStorageServiceProvider);
  return StaffRepositoryImpl(dio, storageService);
});

// StateNotifier quản lý trạng thái Check-in
final staffStateProvider =
    StateNotifierProvider<StaffNotifier, bool>((ref) => StaffNotifier(ref));

class StaffRepositoryImpl implements StaffRepository {
  final Dio dio;
  final StorageService storageService;
  static const String baseApiUrl = AppConstants.baseApiUrl;

  StaffRepositoryImpl(this.dio, this.storageService);

  @override
  Future<bool> checkInStaff() async {
    try {
      // Lấy userId từ Hive Storage
      final Map<String, dynamic>? userStorage = storageService.getObject(
        'user',
        (json) => json,
      );
      if (userStorage == null) {
        throw StaffException("Không tìm thấy ID nhân viên.");
      }
      final String userId = userStorage["userId"] ?? "";
      final response = await dio.put("$baseApiUrl/staffs/$userId/check-in");
      logger.d(response);

      if (response.statusCode == 200) {
        // Lưu trạng thái check-in vào Hive
        await storageService.setValue(key: "staff_checkin", data: "true");
        return true;
      }

      return false;
    } on DioException catch (e) {
      logger.d(e);
      throw StaffException("Lỗi khi check-in nhân viên: ${e.message}");
    }
  }

  @override
  Future<BasePaginatedResponse<StaffOrder>> getStaffOrders(page, size) async {
    // Lấy userId từ Hive Storage
    final Map<String, dynamic>? userStorage = storageService.getObject(
      'user',
      (json) => json,
    );
    if (userStorage == null || !userStorage.containsKey("userId")) {
      throw StaffException("Không tìm thấy ID nhân viên.");
    }

    final String userId = userStorage["userId"];

    try {
      final response = await dio.get(
        "$baseApiUrl/staffs/$userId/order",
        queryParameters: {"page": page, "size": size},
      );

      if (response.statusCode == 200 && response.data != null) {
        return BasePaginatedResponse<StaffOrder>.fromJson(
          response.data,
          (json) => StaffOrder.fromJson(json),
        );
      } else {
        throw StaffException("Không thể lấy danh sách đơn hàng");
      }
    } on DioException catch (e) {
      throw StaffException(
          "Lỗi API: ${e.response?.data?["message"] ?? e.message}");
    }
  }
}

/// Quản lý trạng thái Check-in
class StaffNotifier extends StateNotifier<bool> {
  final Ref ref;

  StaffNotifier(this.ref) : super(false) {
    _loadCheckInStatus();
  }

  Future<void> _loadCheckInStatus() async {
    final storageService = ref.read(localStorageServiceProvider);
    final checkInStatus = storageService.getValue("staff_checkin");
    state = checkInStatus == "true";
  }

  Future<void> checkIn() async {
    final staffRepo = ref.read(staffRepositoryProvider);
    final success = await staffRepo.checkInStaff();
    if (success) state = true;
  }

  Future<BasePaginatedResponse<StaffOrder>> getStaffOrder(page, size) async {
    final staffRepo = ref.read(staffRepositoryProvider);
    final staffOrders = await staffRepo.getStaffOrders(page, size);
    return staffOrders;
  }
}
