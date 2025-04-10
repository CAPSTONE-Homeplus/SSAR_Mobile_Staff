import 'package:flutter/material.dart';
import 'package:home_staff/features/order_detail/view/order_detail_screen.dart';
import 'package:home_staff/infra/staff/entity/staff_order_entity.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;

  const OrderCard({
    Key? key,
    required this.order,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.all(4),
      surfaceTintColor: scheme.surfaceTint,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🏷️ Header: Mã đơn & Trạng thái
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Mã: ${_truncate(order.code, 10)}',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusChip(context, order.status ?? ''),
                ],
              ),
              const SizedBox(height: 12),

              /// 📅 Ngày tạo
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    dateFormat.format(order.createdAt),
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),

              /// ⚠️ Yêu cầu khẩn cấp
              if (order.emergencyRequest == true)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: scheme.errorContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 16, color: scheme.error),
                      const SizedBox(width: 6),
                      Text(
                        "Yêu cầu khẩn cấp",
                        style: textTheme.labelMedium?.copyWith(
                          color: scheme.error,
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

  Widget _buildStatusChip(BuildContext context, String status) {
    final scheme = Theme.of(context).colorScheme;
    final color = _getStatusColor(status, scheme);
    final icon = _getStatusIcon(status);
    final text = _getStatusText(status);

    return Chip(
      avatar: Icon(icon, color: color, size: 16),
      label: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: color,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      shape: StadiumBorder(
        side: BorderSide(color: color.withOpacity(0.4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }

  String _truncate(String input, int maxLength) {
    if (input.length <= maxLength) return input;
    return '...${input.substring(input.length - maxLength)}';
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
