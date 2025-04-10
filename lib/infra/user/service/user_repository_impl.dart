import 'package:home_staff/infra/http/http_service.dart';
import 'package:home_staff/infra/user/entity/user_entity.dart';
import 'package:home_staff/infra/user/service/user_exception.dart';
import 'package:home_staff/infra/user/service/user_repository.dart';
import 'request/get_user_by_id_request.dart';

class UserRepositoryImpl implements UserRepository {
  final HttpService http;

  UserRepositoryImpl(this.http);

  @override
  Future<User> getUserById(String id) async {
    try {
      final result = await http.request(
        GetUserByIdRequest(id: id),
        transformer: (data) => User.fromJson(data),
      );
      return result;
    } catch (e) {
      throw UserException(
          "Không thể lấy thông tin người dùng: ${e.toString()}");
    }
  }
}
