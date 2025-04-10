import 'package:home_staff/helpers/api_constants.dart';
import 'package:home_staff/infra/http/http_service.dart';

class GetHouseByIdRequest extends BaseHttpRequest {
  final String houseId;

  GetHouseByIdRequest({required this.houseId})
      : super(
          endpoint: '/houses/$houseId',
          type: RequestType.get,
          url: ApiConstants.homeCleanBaseUrl,
        );

  @override
  Future<Map<String, dynamic>> toMap() async => {};
}
