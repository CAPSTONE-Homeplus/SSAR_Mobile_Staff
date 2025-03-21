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

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: state.allFieldsValid && !state.isLoading
            ? () async {
                TextInput.finishAutofillContext();
                try {
                  await controller.login(phoneNumber, password);
                  if (context.mounted) {
                    GoRouter.of(context).pushReplacement(RoutePaths.home);
                  }
                } on AuthException catch (e) {
                  if (context.mounted) {
                    SnackbarHelper.showTFSnackbar(context, e.message);
                  }
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: state.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                "Đăng nhập",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
