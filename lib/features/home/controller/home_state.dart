import 'package:home_staff/infra/staff/entity/staff_detail_entity.dart';
import 'package:home_staff/infra/staff/entity/staff_order_entity.dart';

class HomeState {
  final bool isLoading;
  final StaffDetail? staffProfile;
  final List<Order> staffOrders;
  final bool isCheckingIn;
  final String? checkInError;
  final DateTime? lastCheckIn;

  final int currentPage;
  final int totalPages;
  final String? errorMessage;

  const HomeState({
    required this.isLoading,
    this.staffProfile,
    this.staffOrders = const [],
    this.isCheckingIn = false,
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
    List<Order>? staffOrders,
    bool? isCheckingIn,
    String? checkInError,
    DateTime? lastCheckIn,
    int? currentPage,
    int? totalPages,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      staffProfile: staffProfile ?? this.staffProfile,
      staffOrders: staffOrders ?? this.staffOrders,
      isCheckingIn: isCheckingIn ?? this.isCheckingIn,
      checkInError: checkInError ?? this.checkInError,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
