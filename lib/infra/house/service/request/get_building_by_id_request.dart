import 'package:home_staff/helpers/api_constants.dart';
import 'package:home_staff/infra/http/http_service.dart';

class GetBuildingByIdRequest extends BaseHttpRequest {
  final String buildingId;

  GetBuildingByIdRequest({required this.buildingId})
      : super(
          endpoint: "/buildings/$buildingId",
          type: RequestType.get,
          url: ApiConstants.homeCleanBaseUrl,
        );

  @override
  Future<Map<String, dynamic>> toMap() async => {};
}
