// attendance_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceCard extends StatelessWidget {
  final bool checkedIn;
  final DateTime? checkInTime;

  const AttendanceCard({
    Key? key,
    required this.checkedIn,
    required this.checkInTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 0,
      color: theme.colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              checkedIn ? Icons.check_circle : Icons.timelapse,
              color: checkedIn ? Colors.green : Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                checkedIn
                    ? 'Đã check-in lúc ${DateFormat.Hm().format(checkInTime ?? DateTime.now())}'
                    : 'Bạn chưa check-in hôm nay',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
