import 'dart:convert';

class Order {
  final String id;
  final String code;
  final String? note;
  final int? totalAmount;
  final String? status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String address;
  final bool emergencyRequest;

  // Bổ sung các field mới:
  final String? userId;
  final String? serviceType;
  final String? customerFeedback;
  final int? employeeRating;
  final DateTime? bookingDate;
  final DateTime? jobStartTime;
  final DateTime? jobEndTime;
  final int? estimatedDuration;
  final int? actualDuration;
  final DateTime? estimatedArrivalTime;
  final DateTime? cancellationDeadline;
  final List<ExtraService> extraServices;
  final List<Option> options;

  const Order({
    required this.id,
    required this.code,
    this.note,
    this.totalAmount,
    this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.address,
    required this.emergencyRequest,
    this.userId,
    this.serviceType,
    this.customerFeedback,
    this.employeeRating,
    this.bookingDate,
    this.jobStartTime,
    this.jobEndTime,
    this.estimatedDuration,
    this.actualDuration,
    this.estimatedArrivalTime,
    this.cancellationDeadline,
    this.extraServices = const [],
    this.options = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      code: json['code'],
      note: json['note'],
      totalAmount: json['totalAmount'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      address: json['address'],
      emergencyRequest: json['emergencyRequest'] ?? false,
      userId: json['userId'],
      serviceType: json['serviceType'],
      customerFeedback: json['customerFeedback'],
      employeeRating: json['employeeRating'],
      bookingDate: _tryParseDate(json['bookingDate']),
      jobStartTime: _tryParseDate(json['jobStartTime']),
      jobEndTime: _tryParseDate(json['jobEndTime']),
      estimatedArrivalTime: _tryParseDate(json['estimatedArrivalTime']),
      cancellationDeadline: _tryParseDate(json['cancellationDeadline']),
      estimatedDuration: json['estimatedDuration'],
      actualDuration: json['actualDuration'],
      extraServices: (json['extraServices'] as List<dynamic>? ?? [])
          .map((e) => ExtraService.fromJson(e))
          .toList(),
      options: (json['options'] as List<dynamic>? ?? [])
          .map((e) => Option.fromJson(e))
          .toList(),
    );
  }

  // Parse steps từ note
  List<OrderStep> get steps {
    try {
      final decoded = jsonDecode(note ?? '') as Map<String, dynamic>;
      final steps = decoded['Steps'] as List<dynamic>;
      return steps.map((e) => OrderStep.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static DateTime? _tryParseDate(dynamic dateStr) {
    if (dateStr == null) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }
}

class ExtraService {
  final String id;
  final String name;
  final int price;

  ExtraService({
    required this.id,
    required this.name,
    required this.price,
  });

  factory ExtraService.fromJson(Map<String, dynamic> json) {
    return ExtraService(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }
}

class OrderStep {
  final String title;
  final String description;
  final String? time;
  final String status;
  final List<SubActivity>? subActivities;

  OrderStep({
    required this.title,
    required this.description,
    this.time,
    required this.status,
    this.subActivities,
  });

  factory OrderStep.fromJson(Map<String, dynamic> json) {
    return OrderStep(
      title: json['Title'],
      description: json['Description'],
      time: json['Time'],
      status: json['Status'],
      subActivities: (json['SubActivities'] as List<dynamic>?)
              ?.map((e) => SubActivity.fromJson(e))
              .toList() ??
          [],
    );
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

  factory SubActivity.fromJson(Map<String, dynamic> json) {
    return SubActivity(
      activityId: json['ActivityId'],
      title: json['Title'],
      estimatedTime: json['EstimatedTime'],
      status: json['Status'],
    );
  }
}

class Option {
  final String id;
  final String name;
  final int price;
  final bool isMandatory;

  Option({
    required this.id,
    required this.name,
    required this.price,
    required this.isMandatory,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      isMandatory: json['isMandatory'] ?? false,
    );
  }
}
