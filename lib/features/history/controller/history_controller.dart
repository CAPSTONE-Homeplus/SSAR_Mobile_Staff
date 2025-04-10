import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/features/history/controller/history_state.dart';
import 'package:home_staff/infra/staff/service/staff_provider.dart';
import 'package:home_staff/infra/storage/hive_storage_service.dart';
import 'package:home_staff/infra/storage/storage_service.dart';
import 'package:logger/logger.dart';

final logger = Logger();

final historyControllerProvider =
    StateNotifierProvider<HistoryController, HistoryState>((ref) {
  return HistoryController(ref);
});

class HistoryController extends StateNotifier<HistoryState> {
  final Ref ref;

  HistoryController(this.ref) : super(HistoryState.initial());

  Future<void> loadHistory({int page = 1, int size = 100}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final storage = ref.read(localStorageServiceProvider);
      final userStorage =
          storage.getObject<Map<String, dynamic>>('user', (json) => json);
      final userId = userStorage?["userId"];

      if (userId == null || userId.isEmpty) {
        throw Exception("Không tìm thấy staff ID trong bộ nhớ.");
      }

      final staffRepo = ref.read(staffRepositoryProvider);

      final profile = await staffRepo.getStaffById(userId);
      final response = await staffRepo.getStaffOrders(page, size);

      state = state.copyWith(
        staffProfile: profile,
        staffOrders: response.items,
        currentPage: page,
        totalPages: response.totalPages,
        isLoading: false,
      );
    } catch (e) {
      logger.e("Lỗi khi tải dữ liệu lịch sử: $e");
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Lỗi khi tải dữ liệu lịch sử",
      );
    }
  }

  Future<void> refreshOrders() async {
    await loadHistory(page: state.currentPage, size: 100);
  }
}
