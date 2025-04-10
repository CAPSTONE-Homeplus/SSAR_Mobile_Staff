import 'package:home_staff/helpers/api_constants.dart';
import 'package:home_staff/infra/http/http_service.dart';

class CheckInRequest extends BaseHttpRequest {
  final String userId;

  CheckInRequest({required this.userId})
      : super(
          endpoint: "/staffs/$userId/check-in",
          type: RequestType.put,
          url: ApiConstants.homeCleanBaseUrl,
        );

  @override
  Future<Map<String, dynamic>> toMap() async => {};
}
