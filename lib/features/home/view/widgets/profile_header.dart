import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/features/home/view/widgets/notification_popover.dart';
import 'package:home_staff/infra/signalr/tracking_signalr_provider.dart';
import 'package:home_staff/infra/staff/entity/staff_detail_entity.dart';
import 'package:home_staff/shared/services/sound_service.dart';

final notificationReadStateProvider = StateProvider<bool>((ref) => false);

class ProfileHeader extends ConsumerStatefulWidget {
  final StaffDetail? staffProfile;

  const ProfileHeader({super.key, required this.staffProfile});

  @override
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  OverlayEntry? _popoverEntry;
  int _lastNotificationCount = 0;
  bool _isNotificationRead = false;

  void _togglePopover(BuildContext context) {
    if (_popoverEntry != null) {
      _popoverEntry!.remove();
      _popoverEntry = null;
      return;
    }

    // Đánh dấu là đã xem thông báo khi nhấn vào chuông
    setState(() {
      _isNotificationRead = true;
    });
    // Cập nhật state provider để các phần khác của ứng dụng biết rằng thông báo đã được đọc
    ref.read(notificationReadStateProvider.notifier).state = true;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _popoverEntry = OverlayEntry(
      builder: (_) => Positioned(
        top: position.dy + 60,
        right: 16,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: NotificationPopover(
            onClose: () {
              _popoverEntry?.remove();
              _popoverEntry = null;
            },
          ),
        ),
      ),
    );

    overlay.insert(_popoverEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final notifications = ref.watch(orderTrackingStreamProvider);

    final greeting = now.hour < 12
        ? localizations.goodMorning
        : now.hour < 17
            ? localizations.goodAfternoon
            : localizations.goodEvening;

    final name = widget.staffProfile?.fullName ?? "Nhân viên";
    final role = widget.staffProfile?.jobPosition ?? "Chưa rõ";

    // 👇 Lắng nghe thay đổi thông báo
    notifications.whenData((list) {
      // Chỉ phát âm thanh và cập nhật badge khi:
      // 1. Có thông báo mới (số lượng tăng lên)
      // 2. Người dùng chưa nhấn vào chuông (_isNotificationRead = false)
      if (list.length > _lastNotificationCount && !_isNotificationRead) {
        SoundService.playNotification();
      }
      _lastNotificationCount = list.length;
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : "S",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Tên + chức vụ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$greeting, $name",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Nút thông báo với badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => _togglePopover(context),
                tooltip: localizations.notifications,
              ),
              // Chỉ hiển thị badge khi có thông báo và chưa nhấn vào chuông
              if (_lastNotificationCount > 0 && !_isNotificationRead)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(minWidth: 20),
                    child: Text(
                      '$_lastNotificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
