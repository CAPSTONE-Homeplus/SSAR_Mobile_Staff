import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/http/dio_http_service.dart';
import 'user_repository.dart';
import 'user_repository_impl.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final http = ref.watch(httpServiceProvider);
  return UserRepositoryImpl(http);
});
