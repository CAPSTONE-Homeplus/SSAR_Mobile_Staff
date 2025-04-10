import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/signalr/tracking_signalr_provider.dart';

class SignalRInitializer extends ConsumerStatefulWidget {
  final Widget child;
  const SignalRInitializer({super.key, required this.child});

  @override
  ConsumerState<SignalRInitializer> createState() => _SignalRInitializerState();
}

class _SignalRInitializerState extends ConsumerState<SignalRInitializer> {
  bool _hasConnected = false;

  @override
  void initState() {
    super.initState();
    _initSignalR();
  }

  Future<void> _initSignalR() async {
    if (_hasConnected) return;
    final service = ref.read(trackingSignalRServiceProvider);
    final connected = await service.connect();
    ref.read(signalRConnectionStateProvider.notifier).state = connected;
    _hasConnected = true;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
