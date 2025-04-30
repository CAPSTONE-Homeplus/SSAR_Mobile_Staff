import 'package:home_staff/helpers/base_paginated_response.dart';
import 'package:home_staff/infra/staff/entity/staff_detail_entity.dart';
import 'package:home_staff/infra/staff/entity/staff_order_entity.dart';
import 'package:home_staff/infra/staff/entity/staff_status_entity.dart';

// staff_repository.dart
abstract class StaffRepository {
  Future<bool> checkInStaff();
  Future<bool> checkOutStaff(); // ✅ Thêm dòng này
  Future<BasePaginatedResponse<Order>> getStaffOrders(size, page);
  Future<StaffDetail> getStaffById(String id);
  Future<StaffStatus> getStaffStatus(String staffId, String groupId);
}
