import 'package:home_staff/infra/order/entity/order_entity.dart';

abstract class OrderRepository {
  Future<Order> getOrderById(String id);
  Future<bool> orderCheckIn(String id);
  Future<bool> orderCheckOut(String id);
}
