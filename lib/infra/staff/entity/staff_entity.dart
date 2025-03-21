class StaffProfile {
  final String id;
  final String name;
  final String phoneNumber;
  final String serviceType; // 'cleaning', 'laundry', or 'both'
  final int completedTasks;
  final double rating;

  StaffProfile({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.serviceType,
    required this.completedTasks,
    required this.rating,
  });
}

class Task {
  final String id;
  final String serviceType; // 'cleaning' or 'laundry'
  final String location;
  final String apartmentType;
  final DateTime scheduledTime;
  final String status; // 'pending', 'in_progress', 'completed', 'cancelled'
  final String customerName;

  Task({
    required this.id,
    required this.serviceType,
    required this.location,
    required this.apartmentType,
    required this.scheduledTime,
    required this.status,
    required this.customerName,
  });
}
