import 'package:home_staff/infra/http/http_service.dart';
import 'package:home_staff/infra/order/entity/order_step.dart';
import 'package:home_staff/infra/order/entity/tracking_entity.dart';
import 'package:home_staff/infra/order/service/request/update_tracking_request.dart';
import 'package:home_staff/infra/order/service/tracking_repository.dart';
import 'package:home_staff/infra/order/service/request/get_tracking_request.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final HttpService http;

  TrackingRepositoryImpl(this.http);

  @override
  Future<TrackingResponse> getTrackings(String orderId) async {
    try {
      return await http.request(
        GetTrackingRequest(orderId: orderId),
        transformer: (data) => TrackingResponse.fromJson(data),
      );
    } catch (e) {
      throw Exception("Lỗi khi lấy tracking: $e");
    }
  }

  @override
  Future<bool> updateSubActivity(String orderId, SubActivity activity) async {
    try {
      return await http.request(
        UpdateTrackingActivityRequest(orderId: orderId, activity: activity),
        transformer: (data) => true,
      );
    } catch (e) {
      throw Exception("Lỗi khi cập nhật hoạt động: $e");
    }
  }
}
