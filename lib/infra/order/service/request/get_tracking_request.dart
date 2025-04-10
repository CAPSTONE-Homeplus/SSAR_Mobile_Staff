import 'package:home_staff/helpers/api_constants.dart';
import 'package:home_staff/infra/http/http_service.dart';

class GetTrackingRequest extends BaseHttpRequest {
  final String orderId;

  GetTrackingRequest({required this.orderId})
      : super(
          endpoint: "/orders/$orderId/tracking",
          type: RequestType.get,
          url: ApiConstants.homeCleanBaseUrl,
        );

  @override
  Future<Map<String, dynamic>> toMap() async => {};
}
