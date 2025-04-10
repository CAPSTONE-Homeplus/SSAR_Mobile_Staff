// 📦 Model: OrderTrackingSignalR (tách riêng từ SignalR)
import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/http/dio_http_service.dart';
import 'package:home_staff/infra/signalr/base_signalr_response.dart';
import 'package:home_staff/infra/signalr/order_tracking_signalR.dart';
import 'package:logger/logger.dart';
import 'package:signalr_netcore/signalr_client.dart';

class OrderTrackingSignalRService {
  final Ref ref;
  final _logger = Logger();

  late final HubConnection _hubConnection;
  final _controller = StreamController<OrderTrackingSignalR>.broadcast();

  bool _isConnected = false;
  bool _isConnecting = false;

  Stream<OrderTrackingSignalR> get trackingStream => _controller.stream;
  bool get isConnected => _isConnected;

  OrderTrackingSignalRService(this.ref);

  Future<bool> connect() async {
    if (_isConnected || _isConnecting) {
      _logger.d("⚠️ SignalR already connecting or connected");
      return _isConnected;
    }

    _isConnecting = true;

    try {
      final token = await ref.read(tokenProvider.future);
      _logger.d("🔐 Token: $token");

      _hubConnection = HubConnectionBuilder()
          .withUrl(
        'https://homeclean.vinhomesresident.com/homeCleanHub',
        options: HttpConnectionOptions(
          accessTokenFactory: () async => token,
        ),
      )
          .withAutomaticReconnect(
              retryDelays: [2000, 5000, 10000, 20000, 30000]).build();

      _setupConnectionHandlers();
      _setupListeners();

      await _hubConnection.start();
      _isConnected = true;
      _logger.i("✅ SignalR connected");
    } catch (e, st) {
      _isConnected = false;
      _logger.e("❌ SignalR connection failed", error: e, stackTrace: st);
    } finally {
      _isConnecting = false;
    }

    return _isConnected;
  }

  void _setupConnectionHandlers() {
    _hubConnection.onreconnecting(({error}) {
      _isConnected = false;
      _logger.w("🔁 Reconnecting... ${error?.toString() ?? ''}");
    });

    _hubConnection.onreconnected(({connectionId}) {
      _isConnected = true;
      _logger.i("🔌 Reconnected with ID: $connectionId");
    });

    _hubConnection.onclose(({error}) {
      _isConnected = false;
      _logger.w("🛑 Connection closed: ${error?.toString() ?? ''}");
    });
  }

  void _setupListeners() {
    _hubConnection.on('ReceiveNotificationToUser', (arguments) {
      try {
        if (arguments == null || arguments.isEmpty) {
          _logger.w("⚠️ No arguments from SignalR");
          return;
        }

        final raw = arguments.first;
        if (raw is! String) {
          _logger.e("❌ Expected string payload, got: $raw");
          return;
        }

        final json = jsonDecode(raw);
        _logger.d("📨 Raw JSON: $json");

        final response = BaseSignalrResponse<OrderTrackingSignalR>.fromJson(
          json,
          (data) => OrderTrackingSignalR.fromJson(data),
        );

        final tracking = response.data;
        _logger.i("📦 New order: ${tracking.orderId} @ ${tracking.createdAt}");

        _controller.add(tracking);
      } catch (e, st) {
        _logger.e("❌ Failed to parse tracking", error: e, stackTrace: st);
      }
    });
  }

  Future<void> disconnect() async {
    try {
      if (_hubConnection.state == HubConnectionState.Connected ||
          _hubConnection.state == HubConnectionState.Reconnecting) {
        await _hubConnection.stop();
        _logger.d("🔌 SignalR disconnected");
      }
    } catch (e, st) {
      _logger.e("❌ Disconnect error", error: e, stackTrace: st);
    } finally {
      _isConnected = false;
    }
  }

  void dispose() {
    _controller.close();
    disconnect();
  }
}
