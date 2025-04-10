// controller/profile_state.dart
import 'package:home_staff/infra/staff/entity/staff_detail_entity.dart';

class ProfileState {
  final bool isLoading;
  final StaffDetail? staff;
  final String? error;

  const ProfileState({
    this.isLoading = false,
    this.staff,
    this.error,
  });

  ProfileState copyWith({
    bool? isLoading,
    StaffDetail? staff,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      staff: staff ?? this.staff,
      error: error ?? this.error,
    );
  }
}
