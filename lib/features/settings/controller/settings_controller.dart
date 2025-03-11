import 'package:home_staff/features/settings/controller/settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeNotifierProvider<SettingsController, SettingsState>
    settingsControllerProvider =
    NotifierProvider.autoDispose<SettingsController, SettingsState>(
  () => SettingsController(),
);

class SettingsController extends AutoDisposeNotifier<SettingsState> {
  @override
  SettingsState build() {
    return const SettingsState();
  }
}
