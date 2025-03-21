import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<bool> login(UserEntity user);
}
