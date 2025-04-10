import 'package:home_staff/infra/http/http_service.dart';
import 'package:home_staff/infra/order/entity/order_step.dart';

class UpdateTrackingActivityRequest extends BaseHttpRequest {
  final String orderId;
  final SubActivity activity;

  UpdateTrackingActivityRequest({
    required this.orderId,
    required this.activity,
  }) : super(
          endpoint: "/orders/$orderId/tracking/activity",
          type: RequestType.put,
        );

  @override
  Future<Map<String, dynamic>> toMap() async => activity.toJson();
}
