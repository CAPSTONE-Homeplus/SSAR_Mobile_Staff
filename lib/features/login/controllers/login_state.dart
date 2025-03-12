import 'package:equatable/equatable.dart';

import '../../../infra/auth/entity/auth_entity.dart';

class LoginState {
  final bool isLoading;
  final AuthEntity? authEntity;
  final String? errorMessage;
  final bool allFieldsValid;

  LoginState({
    this.isLoading = false,
    this.authEntity,
    this.errorMessage,
    this.allFieldsValid = false,
  });

  LoginState copyWith({
    bool? isLoading,
    AuthEntity? authEntity,
    String? errorMessage,
    bool? allFieldsValid,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      authEntity: authEntity ?? this.authEntity,
      errorMessage: errorMessage ?? this.errorMessage,
      allFieldsValid: allFieldsValid ?? this.allFieldsValid,
    );
  }
}
