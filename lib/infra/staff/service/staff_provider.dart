import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/http/dio_http_service.dart';
import 'package:home_staff/infra/staff/service/staff_repository.dart';
import 'package:home_staff/infra/staff/service/staff_repository_impl.dart';
import 'package:home_staff/infra/storage/storage_service.dart';

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  final http = ref.watch(httpServiceProvider);
  final storage = ref.watch(localStorageServiceProvider);
  return StaffRepositoryImpl(http, storage);
});
