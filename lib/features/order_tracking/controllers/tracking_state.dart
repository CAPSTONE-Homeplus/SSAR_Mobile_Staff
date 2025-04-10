import 'package:home_staff/infra/order/entity/order_step.dart';
// import 'package:home_staff/infra/order/entity/tracking_entity.dart';

enum TrackingStatus {
  initial,
  loading,
  loaded,
  updating,
  error,
}

class TrackingState {
  final TrackingStatus status;
  final List<OrderStep> steps;
  final String? errorMessage;
  final bool isUpdatingActivity;
  final String? updatingActivityId;

  TrackingState({
    this.status = TrackingStatus.initial,
    this.steps = const [],
    this.errorMessage,
    this.isUpdatingActivity = false,
    this.updatingActivityId,
  });

  /// Get Step 4 (or any step with subActivities)
  OrderStep? get stepWithActivities {
    try {
      return steps.firstWhere(
        (step) => step.subActivities != null && step.subActivities!.isNotEmpty,
      );
    } catch (e) {
      return steps.isNotEmpty && steps.length >= 4 ? steps[3] : null;
    }
  }

  /// Helper to check if currently loading
  bool get isLoading => status == TrackingStatus.loading;

  /// Helper to check if there's an error
  bool get hasError => status == TrackingStatus.error;

  /// Create a new state with updated values
  TrackingState copyWith({
    TrackingStatus? status,
    List<OrderStep>? steps,
    String? errorMessage,
    bool? isUpdatingActivity,
    String? updatingActivityId,
  }) {
    return TrackingState(
      status: status ?? this.status,
      steps: steps ?? this.steps,
      errorMessage: errorMessage,
      isUpdatingActivity: isUpdatingActivity ?? this.isUpdatingActivity,
      updatingActivityId: updatingActivityId,
    );
  }
}
