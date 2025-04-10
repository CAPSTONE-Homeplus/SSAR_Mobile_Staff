import 'package:home_staff/infra/order/entity/order_step.dart';

class TrackingResponse {
  final String orderId;
  final List<OrderStep> steps;

  TrackingResponse({
    required this.orderId,
    required this.steps,
  });

  factory TrackingResponse.fromJson(Map<String, dynamic> json) {
    return TrackingResponse(
      orderId: json['orderId'] ?? '',
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => OrderStep.fromJson(e))
              .toList() ??
          [],
    );
  }
}
