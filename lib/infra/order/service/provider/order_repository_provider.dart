import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/http/dio_http_service.dart';
import 'package:home_staff/infra/order/service/order_repository.dart';
import 'package:home_staff/infra/order/service/order_repository_impl.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final http = ref.watch(httpServiceProvider);
  return OrderRepositoryImpl(http);
});
