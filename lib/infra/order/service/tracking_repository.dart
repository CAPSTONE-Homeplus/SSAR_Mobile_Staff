import 'package:home_staff/infra/order/entity/order_step.dart';
import 'package:home_staff/infra/order/entity/tracking_entity.dart';

abstract class TrackingRepository {
  Future<TrackingResponse> getTrackings(String orderId);
  Future<bool> updateSubActivity(String orderId, SubActivity activity);
}
