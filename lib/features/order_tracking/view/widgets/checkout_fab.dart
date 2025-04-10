import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/features/order_detail/controllers/order_detail_controller.dart';
import 'package:home_staff/features/order_tracking/controllers/order_tracking_controller.dart';
import 'package:home_staff/infra/order/entity/order_step.dart';

class CheckoutFloatingButton extends ConsumerWidget {
  final String orderId;
  final List<OrderStep> steps;

  const CheckoutFloatingButton({
    super.key,
    required this.orderId,
    required this.steps,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final canCheckout = _canShowCheckout(steps);

    if (!canCheckout) return const SizedBox.shrink();

    return FloatingActionButton.extended(
      onPressed: () => _handleCheckOut(context, ref),
      icon: const Icon(Icons.check_circle_outline),
      label: const Text("Hoàn Thành"),
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      elevation: 4,
    );
  }

  bool _canShowCheckout(List<OrderStep> steps) {
    if (steps.length < 4) return false;
    final step4 = steps[3];
    if (step4.status != 'InProgress') return false;

    final subActs = step4.subActivities ?? [];
    return subActs.isNotEmpty &&
        subActs.every((act) => act.status == 'Completed');
  }

  Future<void> _handleCheckOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hoàn thành'),
        content: const Text(
          'Bạn có chắc chắn muốn hoàn thành công việc này không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hoàn thành'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final success = await ref
          .read(orderDetailControllerProvider(orderId).notifier)
          .checkOutOrder();

      if (context.mounted) Navigator.of(context).pop(); // Close loading

      if (success) {
        await ref
            .read(orderTrackingControllerProvider(orderId).notifier)
            .fetchOrderSteps();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Đã hoàn thành công việc'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(); // Quay lại màn hình trước
        }
      } else {
        _showErrorSnackBar(context, 'Không thể hoàn thành công việc');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        _showErrorSnackBar(context, 'Lỗi: ${e.toString()}');
      }
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
