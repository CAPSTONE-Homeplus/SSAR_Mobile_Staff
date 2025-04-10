// view/widgets/logout_button.dart
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButton({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onLogout,
      icon: const Icon(Icons.logout),
      label: const Text("Đăng xuất"),
      style: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
        minimumSize: const Size.fromHeight(48),
      ),
    );
  }
}
