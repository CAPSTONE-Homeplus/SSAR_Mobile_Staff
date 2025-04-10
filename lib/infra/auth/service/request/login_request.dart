import 'package:home_staff/helpers/api_constants.dart';
import 'package:home_staff/infra/http/http_service.dart';

import '../../entity/user_entity.dart';

class LoginRequest extends BaseHttpRequest {
  final UserEntity user;

  LoginRequest({required this.user})
      : super(
          endpoint: "/auth/login-staff",
          type: RequestType.post,
          url: ApiConstants.homeCleanBaseUrl,
        );

  @override
  Future<Map<String, dynamic>> toMap() async => {
        "phoneNumber": user.phoneNumber,
        "password": user.password,
      };
}
