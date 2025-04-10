import 'package:flutter/material.dart';
import 'package:home_staff/infra/order/entity/order_step.dart';

class StepItemCard extends StatelessWidget {
  final OrderStep step;
  final int index;

  const StepItemCard({
    Key? key,
    required this.step,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getStatusColor() {
      if (step.isCompleted) return Colors.green;
      if (step.isInProgress) return Colors.orange;
      return Colors.grey;
    }

    IconData getStatusIcon() {
      if (step.isCompleted) return Icons.check_circle;
      if (step.isInProgress) return Icons.timelapse;
      return Icons.circle_outlined;
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: getStatusColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getStatusColor().withOpacity(0.1),
              ),
              child: Icon(
                getStatusIcon(),
                color: getStatusColor(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    step.description,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  if (step.time != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Thời gian: ${_formatDateTime(step.time!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: getStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getStatusText(step.status),
                style: TextStyle(
                  color: getStatusColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Completed':
        return 'Hoàn thành';
      case 'InProgress':
        return 'Đang thực hiện';
      default:
        return 'Chờ thực hiện';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}
