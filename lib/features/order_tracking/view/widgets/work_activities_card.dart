import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/features/order_tracking/controllers/order_tracking_controller.dart';
import 'package:home_staff/infra/order/entity/order_step.dart';

class WorkActivitiesCard extends ConsumerWidget {
  final OrderStep? step;
  final String orderId;

  const WorkActivitiesCard({
    Key? key,
    required this.step,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (step == null ||
        step!.subActivities == null ||
        step!.subActivities!.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Các hoạt động cần thực hiện',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${step!.title}: ${step!.description}',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: step!.subActivities!.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final activity = step!.subActivities![index];
              return ActivityListItem(
                activity: activity,
                orderId: orderId,
              );
            },
          ),
        ],
      ),
    );
  }
}

class ActivityListItem extends ConsumerWidget {
  final SubActivity activity;
  final String orderId;

  const ActivityListItem({
    Key? key,
    required this.activity,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderTrackingControllerProvider(orderId));
    final isUpdating = state.isUpdatingActivity &&
        state.updatingActivityId == activity.activityId;

    return ListTile(
      leading: isUpdating
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : _buildStatusIcon(activity.status),
      title: Text(
        activity.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Thời gian ước tính: ${activity.estimatedTime}'),
      trailing: activity.isCompleted
          ? Icon(Icons.check_circle, color: Colors.green[600])
          : IconButton(
              icon: Icon(
                activity.isInProgress
                    ? Icons.check_circle_outline
                    : Icons.play_circle_outline,
                color: activity.isInProgress
                    ? Colors.green[600]
                    : Colors.blue[600],
              ),
              onPressed:
                  isUpdating ? null : () => _handleActivityAction(context, ref),
            ),
    );
  }

  Future<void> _handleActivityAction(
      BuildContext context, WidgetRef ref) async {
    final isCompleting = activity.isInProgress;
    final newStatus = isCompleting ? 'Completed' : 'InProgress';
    final actionText = isCompleting ? 'hoàn thành' : 'bắt đầu';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận hành động'),
        content: Text('Bạn có chắc muốn $actionText hoạt động này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final updatedActivity = SubActivity(
      activityId: activity.activityId,
      title: activity.title,
      estimatedTime: activity.estimatedTime,
      status: newStatus,
    );

    ref
        .read(orderTrackingControllerProvider(orderId).notifier)
        .updateSubActivity(updatedActivity);
  }

  Widget _buildStatusIcon(String status) {
    switch (status) {
      case 'Completed':
        return const CircleAvatar(
          backgroundColor: Colors.green,
          radius: 14,
          child: Icon(Icons.check, color: Colors.white, size: 16),
        );
      case 'InProgress':
        return const CircleAvatar(
          backgroundColor: Colors.orange,
          radius: 14,
          child: Icon(Icons.timelapse, color: Colors.white, size: 16),
        );
      default:
        return const CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 14,
          child: Icon(Icons.schedule, color: Colors.white, size: 16),
        );
    }
  }
}
