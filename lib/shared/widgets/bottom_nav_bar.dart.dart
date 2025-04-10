import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:home_staff/routing/router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  int _getCurrentIndex(String location) {
    if (location.startsWith(RoutePaths.home)) return 0;
    if (location.startsWith(RoutePaths.history)) return 1;
    if (location.startsWith(RoutePaths.profile)) return 2;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RoutePaths.home);
        break;
      case 1:
        context.go(RoutePaths.history);
        break;
      case 2:
        context.go(RoutePaths.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _getCurrentIndex(location);

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => _onItemTapped(context, index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        NavigationDestination(
          icon: Icon(Icons.history),
          label: 'Lịch sử',
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Tài khoản',
        ),
      ],
    );
  }
}
