import 'package:home_staff/helpers/api_constants.dart';
import 'package:home_staff/infra/http/http_service.dart';

class GetStaffByIdRequest extends BaseHttpRequest {
  final String staffId;

  GetStaffByIdRequest({required this.staffId})
      : super(
          endpoint: "/staffs/$staffId",
          type: RequestType.get,
          url: ApiConstants.homeCleanBaseUrl,
        );

  @override
  Future<Map<String, dynamic>> toMap() async => {};
}
