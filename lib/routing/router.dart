import 'package:home_staff/features/home/view/home_page.dart';
import 'package:home_staff/features/login/view/login_screen.dart';
import 'package:home_staff/features/splash/view/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutePaths {
  static const String splash = '/';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String start = '/start';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String editProfile = '/edit_profile';
  static const String settings = '/settings';
  static const String tripDetails = '/trip_details';
  static const String tripMap = '/trip_map';
  static const String plannerCreator = '/plannerCreator';
  static const String locationPicker = '/locationPicker';
}

final GoRouter router = GoRouter(
  initialLocation: RoutePaths.splash,
  observers: [SimpleNavigationObserver()],
  routes: <RouteBase>[
    GoRoute(
      path: RoutePaths.splash,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
      routes: const <RouteBase>[],
    ),
    GoRoute(
      path: RoutePaths.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: const <RouteBase>[],
    ),
    GoRoute(
      path: RoutePaths.login,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
      routes: const <RouteBase>[],
    ),
  ],
);

extension GoRouterEXT on GoRouter {
  void pushAndRemoveUntil(String path, [Object? data]) {
    while (canPop()) {
      pop();
    }
    pushReplacement(path, extra: data);
  }
}

class SimpleNavigationObserver extends RouteObserver {
  static String? currentRoute = RoutePaths.splash;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) currentRoute = route.settings.name;
    super.didPush(route, previousRoute);
  }
}
