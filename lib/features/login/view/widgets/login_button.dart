import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:home_staff/helpers/snackbar_helper.dart';
import 'package:home_staff/infra/auth/service/auth_exception.dart';
import 'package:home_staff/routing/router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../controllers/login_controller.dart';

class LoginButton extends ConsumerWidget {
  final String phoneNumber;
  final String password;

  const LoginButton({
    super.key,
    required this.phoneNumber,
    required this.password,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);
    final localizations = AppLocalizations.of(context)!;

    final isEnabled = state.allFieldsValid && !state.isLoading;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: isEnabled
            ? () async {
                TextInput.finishAutofillContext(); // ✅ Close keyboard autofill
                try {
                  await controller.login(phoneNumber, password);
                  if (context.mounted) {
                    context.go(RoutePaths.home);
                  }
                } on AuthException catch (e) {
                  if (context.mounted) {
                    SnackbarHelper.showTFSnackbar(context, e.message);
                  }
                }
              }
            : null,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: state.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                "Đăng nhập",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
