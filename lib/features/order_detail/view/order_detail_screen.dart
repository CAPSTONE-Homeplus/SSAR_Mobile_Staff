import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/features/order_detail/controllers/order_detail_controller.dart';
import 'package:home_staff/features/order_detail/controllers/order_detail_state.dart';
import 'package:home_staff/features/order_detail/view/widgets/customer_info_section.dart';
import 'package:home_staff/features/order_detail/view/widgets/order_info_section.dart';
import 'package:home_staff/features/order_detail/view/widgets/order_services_section.dart';
import 'package:home_staff/features/order_detail/view/widgets/order_steps_section.dart';
import 'package:home_staff/features/order_tracking/view/order_tracking_screen.dart';
import 'package:home_staff/infra/storage/active_order_storage.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  bool _isProcessing = false;
  bool _isCheckedIn = false;

  @override
  void initState() {
    super.initState();
    _checkIfActiveOrder();
  }

  Future<void> _checkIfActiveOrder() async {
    final activeOrderId =
        await ref.read(activeOrderStorageProvider).getActiveOrderId();
    if (activeOrderId == widget.orderId) {
      setState(() => _isCheckedIn = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderDetailControllerProvider(widget.orderId));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết nhiệm vụ',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: state.isLoading
          ? _buildLoading(colorScheme)
          : state.errorMessage != null
              ? _buildError(context, state.errorMessage!)
              : _buildContent(context, state),
    );
  }

  Widget _buildLoading(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Đang tải thông tin đơn hàng...',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 24),
            Text('Không thể tải thông tin đơn hàng',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(message,
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () =>
                  ref.invalidate(orderDetailControllerProvider(widget.orderId)),
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, OrderDetailState state) {
    final order = state.order!;
    final user = state.user!;

    return RefreshIndicator(
      onRefresh: () async =>
          ref.refresh(orderDetailControllerProvider(widget.orderId)),
      child: CustomScrollView(
        slivers: [
          _buildCardSliver(
            OrderInfoSection(
              order: order,
              house: state.house,
              building: state.building,
            ),
          ),
          _buildCardSliver(
            Column(
              children: [
                OrderStepsSection(steps: order.steps),
                const SizedBox(height: 16),
                _buildActionButtons(context, order),
              ],
            ),
          ),
          _buildCardSliver(CustomerInfoSection(user: user)),
          _buildCardSliver(OrderServicesSection(order: order)),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildCardSliver(Widget child) {
    return SliverToBoxAdapter(
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, order) {
    final colorScheme = Theme.of(context).colorScheme;
    final status = order.status;
    final isAccepted = status == 'Accepted';
    final isInProgress = status == 'InProgress';
    final isCompleted = status == 'Completed';

    List<Widget> buttons = [];

    if (isAccepted && !_isCheckedIn) {
      buttons.add(
        _buildButton(
          context,
          'Tiến hành',
          Icons.login,
          colorScheme.primary,
          (id) => _confirmCheckIn(context, id),
          order.id,
        ),
      );
    } else if ((isInProgress || isCompleted) && !_isCheckedIn) {
      buttons.add(
        _buildButton(
          context,
          'Xem chi tiết',
          Icons.info_outline,
          colorScheme.secondary,
          (id) => _navigateToTracking(context, id),
          order.id,
        ),
      );
    } else if (_isCheckedIn) {
      buttons.addAll([
        _buildButton(
          context,
          'Cập nhật tiến độ',
          Icons.check_circle_outline,
          colorScheme.secondary,
          (id) => _navigateToTracking(context, id),
          order.id,
        ),
      ]);
    }

    return Column(
      children: buttons
          .map((btn) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SizedBox(
                  width: double.infinity,
                  child: btn,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon,
      Color color, Function(String) onPressed,
      [String? id]) {
    return ElevatedButton.icon(
      onPressed: _isProcessing ? null : () => onPressed(id ?? widget.orderId),
      icon: _isProcessing
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
          : Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _navigateToTracking(BuildContext context, String id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrderTrackingScreen(orderId: id),
      ),
    );
  }

  Future<void> _handleCheckIn(String orderId) async {
    setState(() => _isProcessing = true);
    final success = await ref
        .read(orderDetailControllerProvider(orderId).notifier)
        .checkInOrder();
    if (success && mounted) {
      setState(() {
        _isCheckedIn = true;
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã bắt đầu tiến hành công việc'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } else {
      _handleError('Không thể bắt đầu công việc');
    }
  }

  Future<void> _confirmCheckIn(BuildContext context, String orderId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn bắt đầu công việc này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _handleCheckIn(orderId);
      _navigateToTracking(context, orderId);
    }
  }

  void _handleError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
    setState(() => _isProcessing = false);
  }
}
