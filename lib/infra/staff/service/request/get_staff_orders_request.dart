import 'package:home_staff/helpers/api_constants.dart';
import 'package:home_staff/infra/http/http_service.dart';

class GetStaffOrdersRequest extends BaseHttpRequest {
  final String userId;
  final int page;
  final int size;

  GetStaffOrdersRequest({
    required this.userId,
    required this.page,
    required this.size,
  }) : super(
          endpoint: "/staffs/$userId/order",
          type: RequestType.get,
          url: ApiConstants.homeCleanBaseUrl,
        );

  @override
  Future<Map<String, dynamic>> toMap() async => {
        "page": page,
        "size": size,
      };
}
