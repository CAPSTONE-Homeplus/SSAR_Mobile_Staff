class OrderStep {
  final String title;
  final String description;
  final DateTime? time;
  final String status;
  final List<SubActivity>? subActivities;

  OrderStep({
    required this.title,
    required this.description,
    this.time,
    required this.status,
    this.subActivities,
  });

  bool get isCompleted => status == 'Completed';
  bool get isInProgress => status == 'InProgress';
  bool get isPending => status == 'Pending';

  factory OrderStep.fromJson(Map<String, dynamic> json) {
    return OrderStep(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      time: json['time'] != null ? _parseDateTime(json['time']) : null,
      status: json['status'] ?? 'Pending',
      subActivities: json['subActivities'] != null
          ? List<SubActivity>.from(
              json['subActivities'].map((x) => SubActivity.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'time': time?.toIso8601String(),
      'status': status,
      'subActivities': subActivities?.map((x) => x.toJson()).toList(),
    };
  }

  static DateTime _parseDateTime(String dateStr) {
    try {
      // Handle the format MM/dd/yyyy HH:mm:ss
      final parts = dateStr.split(' ');
      if (parts.length == 2) {
        final dateParts = parts[0].split('/');
        final timeParts = parts[1].split(':');

        if (dateParts.length == 3 && timeParts.length == 3) {
          return DateTime(
            int.parse(dateParts[2]), // year
            int.parse(dateParts[0]), // month
            int.parse(dateParts[1]), // day
            int.parse(timeParts[0]), // hour
            int.parse(timeParts[1]), // minute
            int.parse(timeParts[2]), // second
          );
        }
      }

      // Fallback to standard parsing
      return DateTime.parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }
}

class SubActivity {
  final String activityId;
  final String title;
  final String estimatedTime;
  final String status;

  SubActivity({
    required this.activityId,
    required this.title,
    required this.estimatedTime,
    required this.status,
  });

  bool get isCompleted => status == 'Completed';
  bool get isInProgress => status == 'InProgress';
  bool get isPending => status == 'Pending';

  factory SubActivity.fromJson(Map<String, dynamic> json) {
    return SubActivity(
      activityId: json['activityId'] ?? '',
      title: json['title'] ?? '',
      estimatedTime: json['estimatedTime'] ?? '',
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activityId': activityId,
      'title': title,
      'estimatedTime': estimatedTime,
      'status': status,
    };
  }
}
