import 'package:flutter/material.dart';
import 'package:home_staff/infra/order/entity/order_entity.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderStepsSection extends StatefulWidget {
  final List<OrderStep> steps;

  const OrderStepsSection({
    super.key,
    required this.steps,
  });

  @override
  State<OrderStepsSection> createState() => _OrderStepsSectionState();
}

class _OrderStepsSectionState extends State<OrderStepsSection> {
  bool _showAllSteps = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.steps.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Không có thông tin tiến độ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.timeline, size: 20, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Tiến độ nhiệm vụ',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              _getCompletedSteps(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Divider(height: 24),

        // Hiển thị timeline
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          // Hiển thị tất cả bước khi _showAllSteps = true hoặc chỉ 3 bước đầu tiên khi _showAllSteps = false
          itemCount: _showAllSteps
              ? widget.steps.length
              : (widget.steps.length > 3 ? 3 : widget.steps.length),
          itemBuilder: (context, index) {
            final step = widget.steps[index];
            // isLast được xác định dựa trên số bước đang hiển thị
            final isLast = _showAllSteps
                ? index == widget.steps.length - 1
                : (index == 2 || index == widget.steps.length - 1);
            final isCompleted = step.status.toLowerCase() == 'completed';

            return TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.2,
              isLast: isLast,
              indicatorStyle: IndicatorStyle(
                width: 24,
                height: 24,
                indicator: _buildIndicator(isCompleted),
              ),
              beforeLineStyle: LineStyle(
                color: isCompleted ? Colors.green : Colors.grey.shade300,
                thickness: 2,
              ),
              startChild: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  _formatDateTime(step.time),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              endChild: _buildStepContent(context, step),
            );
          },
        ),

        // Nút "Show more" chỉ hiển thị khi có nhiều hơn 3 bước và đang không hiển thị tất cả
        if (widget.steps.length > 3 && !_showAllSteps)
          InkWell(
            onTap: () {
              setState(() {
                _showAllSteps = true;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 40, top: 8),
              child: Text(
                '+ ${widget.steps.length - 3} bước khác',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

        // Nút "Thu gọn" chỉ hiển thị khi đang hiển thị tất cả và có nhiều hơn 3 bước
        if (_showAllSteps && widget.steps.length > 3)
          InkWell(
            onTap: () {
              setState(() {
                _showAllSteps = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 40, top: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.keyboard_arrow_up,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  Text(
                    'Thu gọn',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIndicator(bool isCompleted) {
    return Container(
      decoration: BoxDecoration(
        color:
            isCompleted ? Colors.green : Colors.grey.shade400.withOpacity(0.6),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          )
        ],
        border: Border.all(
          width: 2,
          color: Colors.white,
        ),
      ),
      child: Icon(
        isCompleted ? Icons.check : Icons.radio_button_unchecked,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, OrderStep step) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            step.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (step.subActivities != null && step.subActivities!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: step.subActivities!.map((activity) {
                return Chip(
                  label: Text(
                    activity.title,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: scheme.primary,
                    ),
                  ),
                  backgroundColor: scheme.primary.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  visualDensity: VisualDensity.compact,
                  side: BorderSide.none,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(String? timeStr) {
    if (timeStr == null) return '';
    try {
      final dateTime = DateTime.parse(timeStr);
      return DateFormat('dd/MM HH:mm').format(dateTime);
    } catch (e) {
      return timeStr;
    }
  }

  String _getCompletedSteps() {
    int completed = widget.steps
        .where((step) => step.status.toLowerCase() == 'completed')
        .length;
    return '$completed/${widget.steps.length} hoàn thành';
  }
}
