class StaffProfile {
  final String id;
  final String name;
  final String phoneNumber;
  final String role;
  final String status; // 'cleaning', 'laundry', or 'both'

  StaffProfile({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.status,
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
