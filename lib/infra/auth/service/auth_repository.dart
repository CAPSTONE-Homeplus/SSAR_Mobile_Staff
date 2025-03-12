import '../entity/auth_entity.dart';
import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login(UserEntity user);
  Future<void> logout();
}
