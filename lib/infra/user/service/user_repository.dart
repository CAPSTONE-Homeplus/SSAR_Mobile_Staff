import '../entity/user_entity.dart';

abstract class UserRepository {
  Future<User> getUserById(String id);
}
