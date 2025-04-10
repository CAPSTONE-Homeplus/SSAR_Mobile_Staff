import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../controllers/login_controller.dart';
import 'login_button.dart'; // import button riêng

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>(), const []);
    final controller = ref.read(loginControllerProvider.notifier);
    final phoneNumber = useState('');
    final password = useState('');
    final obscurePassword = useState(true);
    final localizations = AppLocalizations.of(context)!;

    return FormBuilder(
      key: formKey,
      onChanged: () {
        final isValid = formKey.currentState?.validate() ?? false;
        controller.updateFormStatus(isValid);
      },
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPhoneField(localizations, phoneNumber),
            const SizedBox(height: 24),
            _buildPasswordField(localizations, password, obscurePassword),
            const SizedBox(height: 32),
            // Gọi nút login đã tách
            LoginButton(
              phoneNumber: phoneNumber.value,
              password: password.value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField(
      AppLocalizations localizations, ValueNotifier<String> phoneNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        FormBuilderTextField(
          name: 'phoneNumber',
          decoration: InputDecoration(
            fillColor: Colors.transparent,
            hintText: "Nhập số điện thoại",
            hintStyle: const TextStyle(color: Colors.white),
            prefixIcon: const Icon(Icons.phone_android, color: Colors.white),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            errorStyle: const TextStyle(
              color: Colors.white, // ✅ Màu chữ lỗi
              fontSize: 12,
            ),
          ),
          keyboardType: TextInputType.phone,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
                errorText: "Vui lòng nhập số điện thoại"),
            FormBuilderValidators.numeric(
                errorText: "Số điện thoại chỉ chứa số"),
            FormBuilderValidators.minLength(10,
                errorText: "Số điện thoại phải có 10 số"),
            FormBuilderValidators.maxLength(15,
                errorText: "Số điện thoại không quá 15 số"),
          ]),
          style: const TextStyle(
              color: Colors.white), // Chữ khi nhập vào màu trắng

          onChanged: (value) => phoneNumber.value = value ?? '',
          autofillHints: const [AutofillHints.telephoneNumber],
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    AppLocalizations localizations,
    ValueNotifier<String> password,
    ValueNotifier<bool> obscurePassword,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   localizations.password,
        //   style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        // ),
        const SizedBox(height: 8),
        FormBuilderTextField(
          name: 'password',
          obscureText: obscurePassword.value,
          decoration: InputDecoration(
            hintText: "Nhập mật khẩu",
            hintStyle: const TextStyle(color: Colors.white),
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
            fillColor: Colors.transparent,
            errorStyle: const TextStyle(
              color: Colors.white, // ✅ Màu chữ lỗi
              fontSize: 12,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword.value ? Icons.visibility_off : Icons.visibility,
              ),
              color: Colors.white,
              onPressed: () => obscurePassword.value = !obscurePassword.value,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
          style: const TextStyle(
              color: Colors.white), // Chữ khi nhập vào màu trắng

          validator: FormBuilderValidators.required(
              errorText: localizations.passwordRequired),
          onChanged: (value) => password.value = value ?? '',
          autofillHints: const [AutofillHints.password],
        ),
      ],
    );
  }
}
