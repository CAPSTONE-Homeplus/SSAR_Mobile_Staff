import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/order/entity/order_step.dart';
import 'package:home_staff/infra/order/service/provider/tracking_repository_provider.dart';
import 'package:home_staff/infra/order/service/tracking_repository.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class OrderTrackingState {
  final bool isLoading;
  final String? errorMessage;
  final List<OrderStep> steps;
  final bool isUpdatingActivity;
  final String? updatingActivityId;

  OrderTrackingState({
    this.isLoading = false,
    this.errorMessage,
    this.steps = const [],
    this.isUpdatingActivity = false,
    this.updatingActivityId,
  });

  OrderTrackingState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<OrderStep>? steps,
    bool? isUpdatingActivity,
    String? updatingActivityId,
  }) {
    return OrderTrackingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      steps: steps ?? this.steps,
      isUpdatingActivity: isUpdatingActivity ?? this.isUpdatingActivity,
      updatingActivityId: updatingActivityId,
    );
  }

  // Helper to get step 4 (or any step with subActivities)
  OrderStep? get stepWithActivities {
    try {
      return steps.firstWhere(
        (step) => step.subActivities != null && step.subActivities!.isNotEmpty,
      );
    } catch (e) {
      return steps.isNotEmpty && steps.length >= 4 ? steps[3] : null;
    }
  }

  // Helper for error state
  bool get hasError => errorMessage != null;
}

class OrderTrackingController extends StateNotifier<OrderTrackingState> {
  final TrackingRepository _repository;
  final String orderId;

  OrderTrackingController(this._repository, this.orderId)
      : super(OrderTrackingState(isLoading: true)) {
    fetchOrderSteps();
  }

  Future<void> fetchOrderSteps() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Get tracking data from repository
      final response = await _repository.getTrackings(orderId);

      // Update state with loaded steps
      state = state.copyWith(isLoading: false, steps: response.steps);

      logger.d("Loaded ${response.steps.length} steps for order $orderId");
    } catch (e) {
      logger.e("Error fetching steps: $e");
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Update a sub-activity status
  Future<void> updateSubActivity(SubActivity subActivity) async {
    try {
      // Set updating state
      state = state.copyWith(
        isUpdatingActivity: true,
        updatingActivityId: subActivity.activityId,
      );

      // Call repository directly with SubActivity
      final success = await _repository.updateSubActivity(orderId, subActivity);

      if (success) {
        // If update was successful, reload data to get the updated state
        await fetchOrderSteps();
      } else {
        throw Exception('Không thể cập nhật hoạt động');
      }
    } catch (e) {
      logger.e("Error updating activity: $e");
      // Update state with error but keep the current data
      state = state.copyWith(
        errorMessage: 'Lỗi cập nhật: ${e.toString()}',
        isUpdatingActivity: false,
        updatingActivityId: null,
      );
    }
  }

  /// Reset any error state
  void clearError() {
    if (state.hasError) {
      state = state.copyWith(errorMessage: null);
    }
  }
}

final orderTrackingControllerProvider = StateNotifierProvider.family<
    OrderTrackingController, OrderTrackingState, String>((ref, orderId) {
  final repository = ref.watch(trackingRepositoryProvider);
  return OrderTrackingController(repository, orderId);
});
