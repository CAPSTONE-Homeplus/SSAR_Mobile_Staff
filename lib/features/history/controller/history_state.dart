import 'package:home_staff/infra/staff/entity/staff_detail_entity.dart';
import 'package:home_staff/infra/staff/entity/staff_order_entity.dart';

class HistoryState {
  final bool isLoading;
  final StaffDetail? staffProfile;
  final List<Order> staffOrders;
  final int currentPage;
  final int totalPages;
  final String? errorMessage;

  const HistoryState({
    required this.isLoading,
    this.staffProfile,
    this.staffOrders = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  factory HistoryState.initial() => const HistoryState(isLoading: true);

  HistoryState copyWith({
    bool? isLoading,
    StaffDetail? staffProfile,
    List<Order>? staffOrders,
    int? currentPage,
    int? totalPages,
    String? errorMessage,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      staffProfile: staffProfile ?? this.staffProfile,
      staffOrders: staffOrders ?? this.staffOrders,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
