import 'dart:async';

import 'package:home_staff/features/splash/controller/splash_state.dart';
import 'package:home_staff/infra/auth/service/firebase_auth_service.dart';
import 'package:home_staff/infra/http/http_service.dart';
import 'package:home_staff/infra/local_notifications/notification_service.dart';
import 'package:home_staff/infra/storage/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:home_staff/infra/purchases/purchases_service.dart';

final splashControllerProvider = AsyncNotifierProvider.autoDispose<SplashController, SplashState>(
  () => SplashController(),
);

class SplashController extends AutoDisposeAsyncNotifier<SplashState> {
  @override
  FutureOr<SplashState> build() async {
    final user = await ref.read(firebaseUserProvider.future);
    // warmup user id provider
    final userId = ref.read(userIdProvider);
    final http = ref.read(httpServiceProvider);
    final localStorageService = ref.read(localStorageServiceProvider);
    final purchases = ref.read(purchaseServiceProvider);
    final notifications = ref.read(notificationServiceProvider);

    await localStorageService.init();

    await http.init();
    // await purchases.init();
    //
    // await notifications.init();
    return SplashState(user.isAnonymous);
  }
}
