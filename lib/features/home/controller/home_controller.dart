import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/features/home/controller/home_state.dart';
import 'package:home_staff/infra/staff/entity/staff_entity.dart';
import 'package:home_staff/infra/staff/service/staff_repository_impl.dart';
import 'package:logger/logger.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController(ref);
});
final logger = Logger();

class HomeController extends StateNotifier<HomeState> {
  HomeController(this.ref) : super(HomeState(isLoading: true));

  final Ref ref;

  Future<void> loadStaffProfile() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final profile = StaffProfile(
      id: '12345',
      name: 'Nguyễn Văn A',
      phoneNumber: '0912345678',
      serviceType: 'cleaning', // or 'laundry'
      completedTasks: 127,
      rating: 4.8,
    );

    state = state.copyWith(
      staffProfile: profile,
      isLoading: false,
    );
  }

  Future<void> loadTasks() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();
    final tasks = [
      Task(
        id: 't1',
        serviceType: 'cleaning',
        location: 'Rainbow S1.02 - #2312',
        apartmentType: '2 Bedroom Apartment',
        scheduledTime: DateTime(now.year, now.month, now.day, 10, 30),
        status: 'pending',
        customerName: 'Trần Thị B',
      ),
      Task(
        id: 't2',
        serviceType: 'laundry',
        location: 'Masteri Home A3 - #1204',
        apartmentType: 'Studio Apartment',
        scheduledTime: DateTime(now.year, now.month, now.day, 13, 0),
        status: 'pending',
        customerName: 'Lê Văn C',
      ),
      Task(
        id: 't3',
        serviceType: 'cleaning',
        location: 'Origami S2.05 - #1507',
        apartmentType: '1 Bedroom Apartment',
        scheduledTime: DateTime(now.year, now.month, now.day, 15, 30),
        status: 'in_progress',
        customerName: 'Phạm Thị D',
      ),
    ];

    state = state.copyWith(
      tasks: tasks,
      isLoading: false,
    );
  }

  Future<void> checkIn() async {
    try {
      state = state.copyWith(isCheckingIn: true, checkInError: null);

      final staffRepo = ref.read(staffRepositoryProvider);
      final success = await staffRepo.checkInStaff();
      logger.d("Check-in status: $success");
      if (success) {
        final checkInTime = DateTime.now();
        state = state.copyWith(lastCheckIn: checkInTime, isCheckingIn: false);
      } else {
        state = state.copyWith(
            isCheckingIn: false,
            checkInError: "Check-in thất bại, vui lòng thử lại.");
      }
    } catch (e) {
      state = state.copyWith(
          isCheckingIn: false, checkInError: "Lỗi khi check-in: $e");
    }
  }

  /// 🔹 **Mô phỏng lấy thời gian check-in từ local storage**
  DateTime? getLastCheckIn() {
    return state.lastCheckIn;
  }
}
