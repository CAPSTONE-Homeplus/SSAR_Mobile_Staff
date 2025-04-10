import 'package:home_staff/helpers/api_constants.dart';
import 'package:home_staff/infra/http/http_service.dart';

class CheckOutRequest extends BaseHttpRequest {
  final String id;

  CheckOutRequest({required this.id})
      : super(
          endpoint: "/orders/$id/check-out",
          type: RequestType.put,
          url: ApiConstants.homeCleanBaseUrl,
        );

  @override
  Future<Map<String, dynamic>> toMap() async => {};
}
