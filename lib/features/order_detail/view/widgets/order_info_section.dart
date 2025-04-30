import 'package:flutter/material.dart';
import 'package:home_staff/infra/house/entity/building_entity.dart';
import 'package:home_staff/infra/house/entity/house.dart';
import 'package:home_staff/infra/order/entity/order_entity.dart';
import 'package:intl/intl.dart';

class OrderInfoSection extends StatelessWidget {
  final Order order;
  final House? house; // 👈 thêm house
  final Building? building;

  const OrderInfoSection({
    super.key,
    required this.order,
    required this.house,
    required this.building,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###", "vi_VN");
    final totalAmount = order.totalAmount ?? 0;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final address = (house != null && building != null)
        ? '${house!.no}| ${building!.name}'
        : 'Đang tải địa chỉ...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header: Mã đơn + Trạng thái
        Row(
          children: [
            const Icon(Icons.receipt_long, size: 20),
            const SizedBox(width: 8),
            Text(
              'Mã đơn: ${_truncate(order.code, 10)}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            _buildStatusChip(context, order.status ?? 'Không rõ'),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(),

        /// Địa chỉ & Tổng tiền
        _buildInfoRow(context, 'Địa chỉ', address),
        _buildInfoRow(
          context,
          'Tổng tiền',
          '${formatter.format(totalAmount)} Point',
          valueColor: colorScheme.primary,
        ),

        /// Yêu cầu khẩn cấp
        if (order.emergencyRequest)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Chip(
              avatar: const Icon(Icons.warning_amber_rounded,
                  color: Colors.red, size: 16),
              label: const Text(
                "Yêu cầu khẩn cấp",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.red,
                ),
              ),
              backgroundColor: colorScheme.errorContainer.withOpacity(0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.red.withOpacity(0.4)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    final scheme = Theme.of(context).colorScheme;

    late final Color chipColor;
    late final IconData iconData;
    late final String label;

    switch (status.toLowerCase()) {
      case 'draft':
        chipColor = scheme.outline;
        iconData = Icons.edit_note;
        label = 'Nháp';
        break;
      case 'pending':
        chipColor = Colors.orange;
        iconData = Icons.schedule;
        label = 'Đang chờ';
        break;
      case 'accepted':
        chipColor = scheme.primary;
        iconData = Icons.check_circle_outline;
        label = 'Đã chấp nhận';
        break;
      case 'inprogress':
        chipColor = Colors.indigo;
        iconData = Icons.play_arrow_rounded;
        label = 'Đang xử lý';
        break;
      case 'completed':
        chipColor = Colors.teal;
        iconData = Icons.task_alt;
        label = 'Đã hoàn thành';
        break;
      case 'cancelled':
        chipColor = scheme.error;
        iconData = Icons.cancel_outlined;
        label = 'Đã huỷ';
        break;
      case 'scheduled':
        chipColor = scheme.tertiary;
        iconData = Icons.calendar_today;
        label = 'Đã đặt lịch';
        break;
      default:
        chipColor = scheme.outline;
        iconData = Icons.help_outline;
        label = 'Không rõ';
    }

    return Chip(
      avatar: Icon(iconData, color: chipColor, size: 16),
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: chipColor,
        ),
      ),
      backgroundColor: chipColor.withOpacity(0.1),
      shape: StadiumBorder(
        side: BorderSide(color: chipColor.withOpacity(0.4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value,
      {Color? valueColor}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: valueColor ?? theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _truncate(String input, int maxLength) {
    if (input.length <= maxLength) return input;
    return input.substring(input.length - 6);
  }
}
