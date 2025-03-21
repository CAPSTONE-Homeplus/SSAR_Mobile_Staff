import 'package:home_staff/helpers/base_paginated_response.dart';
import 'package:home_staff/infra/staff/entity/staff_order_entity.dart';

abstract class StaffRepository {
  Future<bool> checkInStaff();
  Future<BasePaginatedResponse<StaffOrder>> getStaffOrders(size, page);
}
