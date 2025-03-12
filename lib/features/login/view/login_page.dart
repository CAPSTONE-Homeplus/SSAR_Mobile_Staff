import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:home_staff/helpers/helper_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:home_staff/features/login/controllers/login_controller.dart';
import 'package:home_staff/helpers/snackbar_helper.dart';
import 'package:home_staff/routing/router.dart';
import '../../../infra/auth/service/auth_exception.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>(), const []);
    final controller = ref.read(loginControllerProvider.notifier);
    final state = ref.watch(loginControllerProvider);
    final phoneNumber = useState<String>('');
    final password = useState<String>('');
    final obscurePassword = useState<bool>(true);

    // Get localization strings
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // App Logo
                Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "HomePlus",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      // Replace with your actual logo:
                      // child: Image.asset('assets/images/staff_logo.png', width: 100),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Welcome Text
                Text(
                  context.localization.logInToAccount,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  localizations.staffLoginWelcomeMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Login Form
                FormBuilder(
                  key: formKey,
                  onChanged: () {
                    final isValid = formKey.currentState?.validate() ?? false;
                    controller.updateFormStatus(isValid);
                  },
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Phone Field
                        Text(
                          localizations.phoneNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormBuilderTextField(
                          name: 'phoneNumber',
                          decoration: InputDecoration(
                            hintText: "0xxxxxxxxx",
                            prefixIcon: const Icon(Icons.phone_android),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          autocorrect: false,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(errorText: localizations.phoneNumberRequired),
                            FormBuilderValidators.numeric(errorText: localizations.onlyNumbersAllowed),
                            FormBuilderValidators.minLength(10, errorText: localizations.mustBeAtLeast10Digits),
                            FormBuilderValidators.maxLength(15, errorText: localizations.cannotExceed15Digits),
                          ]),
                          autofillHints: const [AutofillHints.telephoneNumber],
                          onChanged: (value) => phoneNumber.value = value ?? '',
                        ),
                        const SizedBox(height: 24),

                        // Password Field
                        Text(
                          localizations.password,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormBuilderTextField(
                          name: 'password',
                          decoration: InputDecoration(
                            hintText: "••••••••",
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () => obscurePassword.value = !obscurePassword.value,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                          ),
                          obscureText: obscurePassword.value,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(errorText: localizations.passwordRequired),
                          ]),
                          autofillHints: const [AutofillHints.password],
                          onChanged: (value) => password.value = value ?? '',
                        ),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Handle forgot password
                            },
                            child: Text(
                              localizations.forgotPassword ?? "Forgot Password?",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: state.allFieldsValid && !state.isLoading
                                ? () async {
                              TextInput.finishAutofillContext();
                              try {
                                await controller.login(phoneNumber.value, password.value);
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
                              localizations.logIn,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Version info
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
    );
  }
}