import 'package:home_staff/helpers/api_constants.dart';
import 'package:home_staff/infra/http/http_service.dart';

class CheckOutRequest extends BaseHttpRequest {
  final String userId;
  final String groupId;

  CheckOutRequest({
    required this.userId,
    required this.groupId,
  }) : super(
          endpoint: "/staffs/$userId/remove-staff-status?groupId=$groupId",
          type: RequestType.delete,
          url: ApiConstants.homeCleanBaseUrl,
        );

  @override
  Future<Map<String, dynamic>> toMap() async => {}; // Không cần body
}
