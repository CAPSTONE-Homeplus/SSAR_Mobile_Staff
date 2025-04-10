import 'package:flutter/material.dart';
import 'package:home_staff/infra/order/entity/order_entity.dart';
import 'package:intl/intl.dart';

class OrderServicesSection extends StatelessWidget {
  final Order order;

  const OrderServicesSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final formatter = NumberFormat("#,###", "vi_VN");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.miscellaneous_services, size: 20, color: scheme.primary),
            const SizedBox(width: 8),
            Text(
              'Dịch vụ và tùy chọn',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Divider(height: 24),

        /// ─── Dịch vụ thêm ───
        if (order.extraServices.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              'Dịch vụ thêm',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...order.extraServices.map(
            (e) => _buildServiceItem(
              context,
              name: e.name,
              price: '${formatter.format(e.price)}đ',
            ),
          ),
          const SizedBox(height: 12),
        ],

        /// ─── Tuỳ chọn ───
        if (order.options.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              'Tùy chọn',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...order.options.map(
            (e) => _buildServiceItem(
              context,
              name: e.name,
              price: '${formatter.format(e.price)}đ',
            ),
          ),
          const SizedBox(height: 12),
        ],

        /// ─── Feedback ───
        if (order.customerFeedback != null &&
            order.customerFeedback!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              'Phản hồi từ khách hàng:',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.surfaceVariant.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: scheme.outline.withOpacity(0.2)),
            ),
            child: Text(
              '"${order.customerFeedback}"',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildServiceItem(
    BuildContext context, {
    required String name,
    required String price,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            price,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: scheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
