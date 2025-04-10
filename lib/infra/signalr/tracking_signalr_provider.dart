import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/signalr/order_tracking_signalR.dart';
import 'package:home_staff/infra/signalr/order_tracking_signalr_service.dart';
import 'package:logger/logger.dart';

final signalRConnectionStateProvider = StateProvider<bool>((ref) => false);

final trackingSignalRServiceProvider =
    Provider<OrderTrackingSignalRService>((ref) {
  final service = OrderTrackingSignalRService(ref);
  ref.onDispose(service.dispose);
  return service;
});

final signalRConnectProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(trackingSignalRServiceProvider);
  final connected = await service.connect();
  ref.read(signalRConnectionStateProvider.notifier).state = connected;
  return connected;
});

final orderTrackingStreamProvider =
    StreamProvider<List<OrderTrackingSignalR>>((ref) {
  final service = ref.watch(trackingSignalRServiceProvider);
  final logger = Logger();
  final controller = StreamController<List<OrderTrackingSignalR>>();
  final List<OrderTrackingSignalR> buffer = [];

  controller.add(List.unmodifiable(buffer));

  final subscription = service.trackingStream.listen((tracking) {
    buffer.insert(0, tracking);
    if (buffer.length > 20) buffer.removeLast();

    logger.d("📦 New: ${tracking.orderId} at ${tracking.createdAt}");
    controller.add(List.unmodifiable(buffer));
  });

  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
});
