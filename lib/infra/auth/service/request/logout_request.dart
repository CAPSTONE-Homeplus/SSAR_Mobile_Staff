import 'package:home_staff/helpers/api_constants.dart';
import 'package:home_staff/infra/http/http_service.dart';

class LogoutRequest extends BaseHttpRequest {
  LogoutRequest()
      : super(
          endpoint: "/auth/logout",
          type: RequestType.post,
          url: ApiConstants.homeCleanBaseUrl,
        );

  @override
  Future<Map<String, dynamic>> toMap() async => {};
}
