import 'package:flutter/material.dart';
import 'package:home_staff/features/order_detail/view/order_detail_screen.dart';
import 'package:home_staff/infra/staff/entity/staff_order_entity.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;

  const OrderCard({Key? key, required this.order, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    final statusColor = _getStatusColor(order.status ?? "", colorScheme);
    final statusIcon = _getStatusIcon(order.status ?? "");

    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: colorScheme.surfaceVariant,
      child: InkWell(
        onTap: onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailScreen(orderId: order.id),
                ),
              );
            },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Mã đơn & trạng thái
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mã đơn: ${_truncate(order.code, 10)}',
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          _getStatusText(order.status ?? ''),
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Ngày tạo
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    dateFormat.format(order.createdAt),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),

              /// Khẩn cấp
              if (order.emergencyRequest == true)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 16, color: colorScheme.error),
                      const SizedBox(width: 6),
                      Text(
                        "Yêu cầu khẩn cấp",
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _truncate(String input, int maxLength) {
    if (input.length <= maxLength) return input;
    return input.substring(input.length - 6);
  }

  Color _getStatusColor(String status, ColorScheme scheme) {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return scheme.outlineVariant;
      case 'PENDING':
        return scheme.tertiary;
      case 'ACCEPTED':
        return scheme.primary;
      case 'INPROGRESS':
        return scheme.secondary;
      case 'COMPLETED':
        return Colors.teal;
      case 'CANCELLED':
        return scheme.error;
      case 'SCHEDULED':
        return scheme.primaryContainer;
      default:
        return scheme.outline;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return Icons.edit_note;
      case 'PENDING':
        return Icons.schedule;
      case 'ACCEPTED':
        return Icons.check_circle_outline;
      case 'INPROGRESS':
        return Icons.work_history;
      case 'COMPLETED':
        return Icons.task_alt;
      case 'CANCELLED':
        return Icons.highlight_off;
      case 'SCHEDULED':
        return Icons.event_available;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return 'Bản Nháp';
      case 'PENDING':
        return 'Chờ Xác Nhận';
      case 'ACCEPTED':
        return 'Đã Nhận';
      case 'INPROGRESS':
        return 'Đang Thực Hiện';
      case 'COMPLETED':
        return 'Hoàn Thành';
      case 'CANCELLED':
        return 'Đã Huỷ';
      case 'SCHEDULED':
        return 'Đã Lên Lịch';
      default:
        return 'Không Rõ';
    }
  }
}
