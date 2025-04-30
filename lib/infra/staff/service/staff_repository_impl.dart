import 'package:home_staff/helpers/base_paginated_response.dart';
import 'package:home_staff/infra/http/http_service.dart';
import 'package:home_staff/infra/staff/entity/staff_detail_entity.dart';
import 'package:home_staff/infra/staff/entity/staff_order_entity.dart';
import 'package:home_staff/infra/staff/entity/staff_status_entity.dart';
import 'package:home_staff/infra/staff/service/request/check_out_request.dart';
import 'package:home_staff/infra/staff/service/request/get_staff_by_id_request.dart';
import 'package:home_staff/infra/staff/service/request/staff_status_request.dart';
import 'package:home_staff/infra/storage/hive_storage_service.dart';
import 'package:home_staff/infra/storage/storage_service.dart';

import 'request/check_in_request.dart';
import 'request/get_staff_orders_request.dart';
import 'staff_exception.dart';
import 'staff_repository.dart';

class StaffRepositoryImpl implements StaffRepository {
  final HttpService http;
  final StorageService storage;

  StaffRepositoryImpl(this.http, this.storage);

  @override
  Future<bool> checkInStaff() async {
    final userStorage =
        storage.getObject<Map<String, dynamic>>('user', (json) => json);
    if (userStorage == null || userStorage["userId"] == null) {
      throw StaffException("Không tìm thấy ID nhân viên.");
    }

    final userId = userStorage["userId"];

    try {
      await http.request(
        CheckInRequest(userId: userId),
        transformer: (_) => null,
      );

      await storage.setValue(key: "staff_checkin", data: "true");
      return true;
    } catch (e) {
      throw StaffException("Lỗi khi check-in nhân viên.");
    }
  }

  @override
  Future<BasePaginatedResponse<Order>> getStaffOrders(page, size) async {
    final userStorage =
        storage.getObject<Map<String, dynamic>>('user', (json) => json);
    if (userStorage == null || userStorage["userId"] == null) {
      throw StaffException("Không tìm thấy ID nhân viên.");
    }

    final userId = userStorage["userId"];

    try {
      final response = await http.request(
        GetStaffOrdersRequest(userId: userId, page: page, size: size),
        transformer: (data) => BasePaginatedResponse<Order>.fromJson(
          data,
          (json) => Order.fromJson(json),
        ),
      );

      return response;
    } catch (e) {
      throw StaffException("Không thể lấy danh sách đơn hàng.");
    }
  }

  @override
  Future<bool> checkOutStaff() async {
    final userStorage =
        storage.getObject<Map<String, dynamic>>('user', (json) => json);
    final userId = userStorage?["userId"];
    final groupId = userStorage?["groupId"];

    if (userId == null || groupId == null) {
      throw StaffException("Thiếu thông tin userId hoặc groupId.");
    }

    try {
      await http.request(
        CheckOutRequest(userId: userId, groupId: groupId),
        transformer: (_) => null,
      );

      await storage.deleteValue("staff_checkin"); // ✅ xóa cờ checkin
      return true;
    } catch (e) {
      throw StaffException("Lỗi khi check-out nhân viên.");
    }
  }

  @override
  Future<StaffDetail> getStaffById(String id) async {
    try {
      final data = await http.request(
        GetStaffByIdRequest(staffId: id),
        transformer: (json) => StaffDetail.fromJson(json),
      );
      return data;
    } catch (e) {
      throw StaffException("Không thể tải thông tin nhân viên.");
    }
  }

  @override
  Future<StaffStatus> getStaffStatus(String staffId, String groupId) async {
    try {
      final data = await http.request(
        GetStaffStatusRequest(staffId: staffId, groupId: groupId),
        transformer: (json) => StaffStatus.fromJson(json),
      );
      return data;
    } catch (e) {
      throw StaffException("Không thể tải trạng thái nhân viên.");
    }
  }
}
