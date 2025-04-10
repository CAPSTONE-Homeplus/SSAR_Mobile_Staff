// controller/profile_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/staff/service/staff_provider.dart';
import 'package:home_staff/infra/staff/service/staff_repository.dart';
import 'package:home_staff/infra/storage/hive_storage_service.dart';
import 'package:home_staff/infra/storage/storage_service.dart';
import 'package:logger/logger.dart';

import 'profile_state.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  final repo = ref.read(staffRepositoryProvider);
  final storage = ref.read(localStorageServiceProvider);
  return ProfileController(repo, storage);
});

class ProfileController extends StateNotifier<ProfileState> {
  final StaffRepository repo;
  final StorageService storage;
  final _logger = Logger();

  ProfileController(this.repo, this.storage)
      : super(const ProfileState(isLoading: true)) {
    loadStaff();
  }

  Future<void> loadStaff() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user =
          storage.getObject<Map<String, dynamic>>("user", (json) => json);
      final id = user?['userId'];
      if (id == null) throw Exception("Không tìm thấy ID");

      final staff = await repo.getStaffById(id);
      state = state.copyWith(staff: staff, isLoading: false);
    } catch (e, s) {
      _logger.e("❌ Lỗi tải hồ sơ", error: e, stackTrace: s);
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> logout() async {
    await storage.clear();
  }
}
