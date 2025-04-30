import 'package:home_staff/infra/staff/entity/staff_detail_entity.dart';
import 'package:home_staff/infra/staff/entity/staff_order_entity.dart';

class HomeState {
  final bool isLoading;
  final StaffDetail? staffProfile;
  final String? staffStatus; // Thay đổi thành string
  final List<Order> staffOrders;
  final String? checkInError;
  final DateTime? lastCheckIn;

  final int currentPage;
  final int totalPages;
  final String? errorMessage;

  const HomeState({
    required this.isLoading,
    this.staffProfile,
    this.staffStatus,
    this.staffOrders = const [],
    this.checkInError,
    this.lastCheckIn,
    this.currentPage = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  factory HomeState.initial() => const HomeState(isLoading: true);

  HomeState copyWith({
    bool? isLoading,
    StaffDetail? staffProfile,
    String? staffStatus,
    List<Order>? staffOrders,
    String? checkInError,
    DateTime? lastCheckIn,
    int? currentPage,
    int? totalPages,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      staffProfile: staffProfile ?? this.staffProfile,
      staffStatus: staffStatus ?? this.staffStatus,
      staffOrders: staffOrders ?? this.staffOrders,
      checkInError: checkInError ?? this.checkInError,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
