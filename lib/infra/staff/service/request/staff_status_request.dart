import 'package:home_staff/helpers/api_constants.dart';
import 'package:home_staff/infra/http/http_service.dart';

class GetStaffStatusRequest extends BaseHttpRequest {
  final String staffId;
  final String groupId;

  GetStaffStatusRequest({required this.staffId, required this.groupId})
      : super(
          endpoint: "/staffs/$staffId/get-staff-status",
          type: RequestType.get,
          url: ApiConstants.homeCleanBaseUrl,
          queryParameters: {'groupId': groupId},
        );

  @override
  Future<Map<String, dynamic>> toMap() async => {};
}
