import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:home_staff/features/history/view/history_screen.dart';
import 'package:home_staff/features/home/view/home_screen.dart';
import 'package:home_staff/features/login/view/login_screen.dart';
import 'package:home_staff/features/profile/%20%20view/profile_screen.dart';
import 'package:home_staff/features/splash/view/splash_page.dart';
import 'package:home_staff/shared/signalr_initializer.dart';

class RoutePaths {
  static const String splash = '/';
  static const String home = '/home';
  static const String start = '/start';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String editProfile = '/edit_profile';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String history = '/history';
}

final GoRouter router = GoRouter(
  initialLocation: RoutePaths.splash,
  observers: [SimpleNavigationObserver()],
  routes: <RouteBase>[
    /// 🟢 Splash Page
    GoRoute(
      path: RoutePaths.splash,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
    ),

    /// 🏠 Home Page (wrapped with SignalRInitializer)
    GoRoute(
      path: RoutePaths.home,
      builder: (BuildContext context, GoRouterState state) {
        return const SignalRInitializer(child: HomeScreen());
      },
    ),

    /// 🕘 History Page
    GoRoute(
      path: RoutePaths.history,
      builder: (BuildContext context, GoRouterState state) {
        return const SignalRInitializer(child: HistoryScreen());
      },
    ),

    /// 👤 Profile Page
    GoRoute(
      path: RoutePaths.profile,
      builder: (BuildContext context, GoRouterState state) {
        return const SignalRInitializer(child: ProfileScreen());
      },
    ),

    /// 🔐 Login Page
    GoRoute(
      path: RoutePaths.login,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
  ],
);

// 🛠️ Custom push with pop-all + replace
extension GoRouterEXT on GoRouter {
  void pushAndRemoveUntil(String path, [Object? data]) {
    while (canPop()) {
      pop();
    }
    pushReplacement(path, extra: data);
  }
}

// 📡 Route observer (optional tracking)
class SimpleNavigationObserver extends RouteObserver {
  static String? currentRoute = RoutePaths.splash;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) currentRoute = route.settings.name;
    super.didPush(route, previousRoute);
  }
}
