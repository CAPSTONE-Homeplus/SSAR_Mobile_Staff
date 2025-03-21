import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/login_form.dart';
import 'widgets/login_header.dart';
import 'widgets/login_logo.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background Image + Blur
          SizedBox.expand(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/login_background.jpg',
                  fit: BoxFit.cover,
                ),
                BackdropFilter(
                  filter:
                      ImageFilter.blur(sigmaX: 10, sigmaY: 10), // 🔹 Độ blur
                  child: Container(
                    color: Colors.black.withOpacity(0.2), // 🔹 phủ thêm màu mờ
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Foreground content
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    const LoginLogo(),
                    const SizedBox(height: 32),
                    LoginHeader(localizations: localizations),
                    const SizedBox(height: 40),

                    // Login Form Box
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const LoginForm(),
                    ),

                    const SizedBox(height: 24),

                    Center(
                      child: Text(
                        "HomePlus Staff v1.0.0",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
