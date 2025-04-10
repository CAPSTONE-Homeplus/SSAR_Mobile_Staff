import 'package:timezone/timezone.dart';

class AppNotification {
  final String title;
  final String description;
  final TZDateTime scheduledDate;

  AppNotification({
    required this.title,
    required this.description,
    required this.scheduledDate,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      title: json['title'],
      description: json['description'],
      scheduledDate:
          TZDateTime.parse(getLocation('UTC'), json['scheduledDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'scheduledDate': scheduledDate.toIso8601String(),
    };
  }
}
