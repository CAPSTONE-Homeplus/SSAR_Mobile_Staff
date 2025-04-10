import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/features/order_detail/view/order_detail_screen.dart';
import 'package:home_staff/infra/signalr/tracking_signalr_provider.dart';
import 'package:intl/intl.dart';

class NotificationPopover extends ConsumerWidget {
  final VoidCallback onClose;

  const NotificationPopover({super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(signalRConnectionStateProvider);
    final notifications = ref.watch(orderTrackingStreamProvider);
    final scheme = Theme.of(context).colorScheme;

    return Material(
      borderRadius: BorderRadius.circular(16),
      color: scheme.surface,
      elevation: 8,
      child: Container(
        width: 320,
        constraints: const BoxConstraints(maxHeight: 460),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 👈 quan trọng
          children: [
            // 🔔 Header
            Row(
              children: [
                Text(
                  "Thông báo mới",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                  tooltip: 'Đóng',
                ),
              ],
            ),

            const Divider(height: 16),

            // 🔄 Kết nối
            if (!isConnected)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: scheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Đang kết nối tới máy chủ...",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: scheme.onTertiaryContainer,
                          ),
                    ),
                  ],
                ),
              ),

            // 📄 Danh sách
            Expanded(
              child: notifications.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: scheme.error, size: 48),
                      const SizedBox(height: 8),
                      Text("Lỗi khi tải thông báo",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: scheme.error,
                                    fontWeight: FontWeight.bold,
                                  )),
                      const SizedBox(height: 4),
                      Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                data: (list) {
                  if (list.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off_outlined,
                              size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Chưa có thông báo nào",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: scheme.surfaceVariant),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      final createdAt = item.createdAt;
                      final formattedTime = createdAt != null
                          ? DateFormat('HH:mm • dd/MM').format(createdAt)
                          : "Không rõ thời gian";

                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 4),
                        leading: CircleAvatar(
                          backgroundColor: scheme.primaryContainer,
                          child: const Icon(Icons.notifications, size: 20),
                        ),
                        title: Text(
                          "Đơn hàng #${index}",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        subtitle: Text(
                          "Lúc $formattedTime",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderDetailScreen(
                                orderId: item.orderId,
                              ),
                            ),
                          );
                          onClose();
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _truncate(String input, int maxLength) {
  if (input.length <= maxLength) return input;
  return '...${input.substring(input.length - maxLength)}';
}
