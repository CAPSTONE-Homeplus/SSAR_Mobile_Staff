import 'package:home_staff/helpers/api_constants.dart';
import 'package:home_staff/infra/http/http_service.dart';

class GetUserByIdRequest extends BaseHttpRequest {
  final String id;

  GetUserByIdRequest({required this.id})
      : super(
          endpoint: "/users/$id",
          type: RequestType.get,
          url: ApiConstants.winWalletBaseUrl,
        );

  @override
  Future<Map<String, dynamic>> toMap() async => {};
}
