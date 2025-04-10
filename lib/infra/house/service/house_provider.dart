// lib/infra/house/provider/house_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/house/entity/house.dart';
import 'package:home_staff/infra/house/service/house_repository.dart';
import 'package:home_staff/infra/house/service/house_repository_imp.dart';
import 'package:home_staff/infra/http/dio_http_service.dart';

final houseRepositoryProvider = Provider<HouseRepository>((ref) {
  final http = ref.watch(httpServiceProvider);
  return HouseRepositoryImpl(http);
});

final getHouseByIdProvider =
    FutureProvider.family<House, String>((ref, id) async {
  final repo = ref.watch(houseRepositoryProvider);
  return repo.getHouseById(id);
});
