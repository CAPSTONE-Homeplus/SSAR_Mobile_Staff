import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:home_staff/features/home/controller/home_state.dart';
import 'package:home_staff/infra/staff/entity/staff_entity.dart';
import 'package:intl/intl.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final String selectedServiceType;

  const TaskList({
    Key? key,
    required this.tasks,
    required this.selectedServiceType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Filter tasks based on selected service type
    final filteredTasks = selectedServiceType == 'all'
        ? tasks
        : tasks
            .where((task) => task.serviceType == selectedServiceType)
            .toList();

    return filteredTasks.isEmpty
        ? EmptyTasksView(serviceType: selectedServiceType)
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return TaskCard(task: task);
            },
          );
  }
}

class EmptyTasksView extends StatelessWidget {
  final String serviceType;

  const EmptyTasksView({
    Key? key,
    required this.serviceType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            localizations.noTasksAvailable,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            serviceType == 'all'
                ? localizations.checkBackLater
                : localizations.noTasksForSelectedType,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final serviceColor =
        task.serviceType == 'cleaning' ? Colors.blue : Colors.purple;

    final statusColor = task.status == 'pending'
        ? Colors.orange
        : task.status == 'in_progress'
            ? Colors.blue
            : task.status == 'completed'
                ? Colors.green
                : Colors.grey;

    final statusText = task.status == 'pending'
        ? localizations.pending
        : task.status == 'in_progress'
            ? localizations.inProgress
            : task.status == 'completed'
                ? localizations.completed
                : localizations.unknown;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to task detail
          // context.push('${RoutePaths.taskDetail}/${task.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task header with time and status
              TaskHeader(
                serviceType: task.serviceType,
                serviceColor: serviceColor,
                statusText: statusText,
                statusColor: statusColor,
              ),

              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),

              // Task details
              TaskDetails(task: task),

              const SizedBox(height: 16),

              // Action button
              TaskActionButton(status: task.status, taskId: task.id),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskHeader extends StatelessWidget {
  final String serviceType;
  final Color serviceColor;
  final String statusText;
  final Color statusColor;

  const TaskHeader({
    Key? key,
    required this.serviceType,
    required this.serviceColor,
    required this.statusText,
    required this.statusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              serviceType == 'cleaning'
                  ? Icons.cleaning_services_rounded
                  : Icons.local_laundry_service_rounded,
              color: serviceColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              serviceType == 'cleaning'
                  ? localizations.cleaning
                  : localizations.laundry,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: serviceColor,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: statusColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }
}

class TaskDetails extends StatelessWidget {
  final Task task;

  const TaskDetails({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Apartment info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.apartmentInfo,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                task.location,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                task.apartmentType,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),

        // Time info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.scheduledFor,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM d').format(task.scheduledTime),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('h:mm a').format(task.scheduledTime),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TaskActionButton extends StatelessWidget {
  final String status;
  final String taskId;

  const TaskActionButton({
    Key? key,
    required this.status,
    required this.taskId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: status == 'pending'
            ? () {
                // Start task
                // context.push('${RoutePaths.taskDetail}/${taskId}');
              }
            : status == 'in_progress'
                ? () {
                    // Complete task
                    // context.push('${RoutePaths.taskDetail}/${taskId}');
                  }
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: status == 'completed'
              ? Colors.grey[200]
              : Theme.of(context).primaryColor,
          foregroundColor:
              status == 'completed' ? Colors.grey[700] : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          status == 'pending'
              ? localizations.startTask
              : status == 'in_progress'
                  ? localizations.completeTask
                  : localizations.viewDetails,
        ),
      ),
    );
  }
}
