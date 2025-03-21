import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginHeader extends StatelessWidget {
  final AppLocalizations localizations;
  const LoginHeader({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Chào mừng trở lại",
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
