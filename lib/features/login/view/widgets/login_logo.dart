import 'package:flutter/material.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Home Plus",
          style: theme.textTheme.headlineLarge?.copyWith(
            color: theme.colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: const Offset(2, 2),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Ứng dụng dành cho nhân viên",
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSecondary,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: const Offset(1, 1),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
