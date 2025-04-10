import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/http/dio_http_service.dart';
import 'package:home_staff/infra/order/service/tracking_repository.dart';
import 'package:home_staff/infra/order/service/tracking_repository_imp.dart';

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  final http = ref.watch(httpServiceProvider);
  return TrackingRepositoryImpl(http);
});
