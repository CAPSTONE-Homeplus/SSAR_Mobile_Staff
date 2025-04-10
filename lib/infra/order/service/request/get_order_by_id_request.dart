import 'package:home_staff/helpers/api_constants.dart';
import 'package:home_staff/infra/http/http_service.dart';

class GetOrderByIdRequest extends BaseHttpRequest {
  final String id;

  GetOrderByIdRequest({required this.id})
      : super(
          endpoint: "/orders/$id",
          type: RequestType.get,
          url: ApiConstants.homeCleanBaseUrl,
        );

  @override
  Future<Map<String, dynamic>> toMap() async => {};
}
