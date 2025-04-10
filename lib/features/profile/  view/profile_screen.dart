import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:home_staff/features/profile/%20%20view/widgets/logout_button.dart';
import 'package:home_staff/features/profile/%20%20view/widgets/profile_info_section.dart';
import 'package:home_staff/features/profile/controller/profile_controller.dart';
import 'package:home_staff/routing/router.dart'; // để lấy RoutePaths
import 'package:home_staff/shared/layout/app_scaffold.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);
    final controller = ref.read(profileControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: AppBar(
        title: const Text("Tài khoản"),
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text("Lỗi: ${state.error}"))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileInfoSection(staff: state.staff!),
                      const Spacer(),
                      LogoutButton(
                        onLogout: () async {
                          await controller.logout();
                          if (context.mounted) {
                            context.go(RoutePaths.login); // ✅ dùng go_router
                          }
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
