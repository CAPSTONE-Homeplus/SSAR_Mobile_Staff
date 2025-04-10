import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/features/login/controllers/login_state.dart';
import 'package:home_staff/infra/auth/entity/user_entity.dart';
import 'package:logger/logger.dart';

import '../../../infra/auth/service/auth_exception.dart';
import '../../../infra/auth/service/auth_repository_impl.dart';

final loginControllerProvider =
    NotifierProvider.autoDispose<LoginController, LoginState>(
  () => LoginController(),
);

class LoginController extends AutoDisposeNotifier<LoginState> {
  @override
  LoginState build() {
    return LoginState();
  }

  final logger = Logger();

  void updateFormStatus(bool isValid) {
    state = state.copyWith(allFieldsValid: isValid);
  }

  Future<void> login(String phoneNumber, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = UserEntity(phoneNumber: phoneNumber, password: password);
      final authData = await authRepo.login(user);

      state = state.copyWith(
        isLoading: false,
        authEntity: authData,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      throw AuthException(e.toString());
    }
  }
}
