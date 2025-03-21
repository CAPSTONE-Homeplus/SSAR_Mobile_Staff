import 'package:home_staff/infra/staff/entity/staff_entity.dart';

class HomeState {
  final bool isLoading;
  final StaffProfile? staffProfile;
  final List<Task> tasks;
  final bool isCheckingIn; // Trạng thái đang check-in
  final String? checkInError; // Lưu lỗi nếu có
  final DateTime? lastCheckIn; // Thời gian check-in cuối cùng

  HomeState({
    required this.isLoading,
    this.staffProfile,
    this.tasks = const [],
    this.isCheckingIn = false,
    this.checkInError,
    this.lastCheckIn,
  });

  HomeState copyWith({
    bool? isLoading,
    StaffProfile? staffProfile,
    List<Task>? tasks,
    bool? isCheckingIn,
    String? checkInError,
    DateTime? lastCheckIn,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      staffProfile: staffProfile ?? this.staffProfile,
      tasks: tasks ?? this.tasks,
      isCheckingIn: isCheckingIn ?? this.isCheckingIn,
      checkInError: checkInError,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
    );
  }
}
