import 'package:home_staff/infra/http/http_service.dart';
import 'package:home_staff/infra/order/entity/order_entity.dart';
import 'package:home_staff/infra/order/service/order_repository.dart';
import 'package:home_staff/infra/order/service/request/get_order_by_id_request.dart';
import 'package:home_staff/infra/order/service/request/check_in_request.dart';
import 'package:home_staff/infra/order/service/request/check_out_request.dart';
import 'order_exception.dart';

class OrderRepositoryImpl implements OrderRepository {
  final HttpService http;

  OrderRepositoryImpl(this.http);

  @override
  Future<Order> getOrderById(String id) async {
    try {
      final response = await http.request(
        GetOrderByIdRequest(id: id),
        transformer: (data) => Order.fromJson(data),
      );

      return response;
    } catch (e) {
      throw OrderException("Không thể lấy thông tin đơn hàng: ${e.toString()}");
    }
  }

  @override
  Future<bool> orderCheckIn(String id) async {
    try {
      await http.request(
        CheckInRequest(id: id),
        transformer: (_) => true,
      );
      return true;
    } catch (e) {
      throw OrderException("Không thể check-in đơn hàng: ${e.toString()}");
    }
  }

  @override
  Future<bool> orderCheckOut(String id) async {
    try {
      await http.request(
        CheckOutRequest(id: id),
        transformer: (_) => true,
      );
      return true;
    } catch (e) {
      throw OrderException("Không thể check-out đơn hàng: ${e.toString()}");
    }
  }
}
