import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/features/home/controller/home_state.dart';
import 'package:home_staff/infra/staff/service/staff_provider.dart';
import 'package:home_staff/infra/storage/hive_storage_service.dart';
import 'package:home_staff/infra/storage/storage_service.dart';
import 'package:logger/logger.dart';

final logger = Logger();

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController(ref);
});

class HomeController extends StateNotifier<HomeState> {
  final Ref ref;

  HomeController(this.ref) : super(HomeState.initial()) {
    _loadCheckInFromStorage();
  }

  Future<void> _loadCheckInFromStorage() async {
    final storage = ref.read(localStorageServiceProvider);
    final stored = storage.getValue("staff_checkin");
    if (stored == "true") {
      state = state.copyWith(lastCheckIn: DateTime.now());
    }
  }

  Future<void> loadTasksOnly({int page = 1, int size = 300}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final staffRepo = ref.read(staffRepositoryProvider);
      final storage = ref.read(localStorageServiceProvider);
      final userStorage =
          storage.getObject<Map<String, dynamic>>('user', (json) => json);
      final userId = userStorage?["userId"];

      if (userId == null || userId.isEmpty) {
        throw Exception('Không tìm thấy staff ID trong bộ nhớ.');
      }

      final response = await staffRepo.getStaffOrders(page, size);

      state = state.copyWith(
        staffOrders: response.items,
        currentPage: page,
        totalPages: response.totalPages,
        isLoading: false,
      );
    } catch (e) {
      logger.e("Lỗi khi tải đơn hàng: $e");
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Lỗi khi tải danh sách đơn hàng",
      );
    }
  }

  Future<void> loadStaffProfile() async {
    try {
      final storage = ref.read(localStorageServiceProvider);
      final userStorage =
          storage.getObject<Map<String, dynamic>>('user', (json) => json);
      final userId = userStorage?["userId"];
      final groupId = userStorage?["groupId"];

      if (userId == null ||
          userId.isEmpty ||
          groupId == null ||
          groupId.isEmpty) {
        throw Exception('Không tìm thấy staff ID hoặc group ID trong bộ nhớ.');
      }

      final staffRepo = ref.read(staffRepositoryProvider);
      final profile = await staffRepo.getStaffById(userId);
      final staffStatus = await staffRepo.getStaffStatus(userId, groupId);

      state = state.copyWith(
        staffProfile: profile,
        staffStatus: staffStatus.status,
      );
    } catch (e) {
      logger.e("Lỗi khi tải thông tin nhân viên: $e");
    }
  }

  // Các method khác giữ nguyên

  Future<void> checkIn() async {
    try {
      state = state.copyWith(checkInError: null);
      final staffRepo = ref.read(staffRepositoryProvider);
      final storage = ref.read(localStorageServiceProvider);
      final userStorage =
          storage.getObject<Map<String, dynamic>>('user', (json) => json);
      final userId = userStorage?["userId"];
      final groupId = userStorage?["groupId"];

      if (state.staffStatus == 'Offline') {
        final success = await staffRepo.checkInStaff();

        if (success) {
          state = state.copyWith(
            staffStatus: 'Ready', // Chuyển trạng thái
            lastCheckIn: DateTime.now(),
          );
        } else {
          state = state.copyWith(
            checkInError: "Check-in thất bại, vui lòng thử lại.",
          );
        }
      } else {
        state = state.copyWith(
          checkInError: "Bạn không thể check-in ở trạng thái này.",
        );
      }
    } catch (e) {
      state = state.copyWith(
        checkInError: "Lỗi khi check-in: ${e.toString()}",
      );
    }
  }

  Future<void> checkOut() async {
    try {
      state = state.copyWith(checkInError: null);
      final staffRepo = ref.read(staffRepositoryProvider);
      final storage = ref.read(localStorageServiceProvider);
      final userStorage =
          storage.getObject<Map<String, dynamic>>('user', (json) => json);
      final userId = userStorage?["userId"];
      final groupId = userStorage?["groupId"];

      if (state.staffStatus == 'Ready') {
        final success = await staffRepo.checkOutStaff();

        if (success) {
          state = state.copyWith(
            staffStatus: 'Offline', // Chuyển trạng thái
            lastCheckIn: null,
          );
        } else {
          state = state.copyWith(
            checkInError: "Check-out thất bại, vui lòng thử lại.",
          );
        }
      } else {
        state = state.copyWith(
          checkInError: "Bạn không thể check-out ở trạng thái này.",
        );
      }
    } catch (e) {
      state = state.copyWith(
        checkInError: "Lỗi khi check-out: ${e.toString()}",
      );
    }
  }
}
