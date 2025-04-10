import 'package:flutter/material.dart';
import 'package:home_staff/infra/order/entity/order_step.dart';

class ProgressOverviewCard extends StatelessWidget {
  final List<OrderStep> steps;

  const ProgressOverviewCard({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedSteps = steps.where((step) => step.isCompleted).length;
    final totalSteps = steps.length;
    final progress = totalSteps > 0 ? completedSteps / totalSteps : 0.0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: theme.colorScheme.surface,
      surfaceTintColor: theme.colorScheme.surfaceTint,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng quan tiến độ',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: theme.colorScheme.surfaceVariant,
                valueColor:
                    AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đã hoàn thành: $completedSteps/$totalSteps',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
