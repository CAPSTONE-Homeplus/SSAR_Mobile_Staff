import 'dart:convert';

class Order {
  final String id;
  final String code;
  final String? note;
  final String? notes;
  final double? price;
  final int? totalAmount;
  final String? status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String address;
  final bool emergencyRequest;

  // New fields from JSON
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

  // Additional fields from JSON
  final String? employeeId;
  final String? cleaningToolsRequired;
  final String? cleaningToolsProvided;
  final double? distanceToCustomer;
  final String? priorityLevel;
  final String? realTimeStatus;
  final String? cleaningAreas;
  final String? itemsToClean;
  final String? timeSlotId;
  final String? serviceId;
  final String? timeSlotDetail;
  final String? discountCode;
  final double? discountAmount;

  final List<ExtraService> extraServices;
  final List<Option> options;

  const Order({
    required this.id,
    required this.code,
    this.note,
    this.notes,
    this.price,
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
    this.employeeId,
    this.cleaningToolsRequired,
    this.cleaningToolsProvided,
    this.distanceToCustomer,
    this.priorityLevel,
    this.realTimeStatus,
    this.cleaningAreas,
    this.itemsToClean,
    this.timeSlotId,
    this.serviceId,
    this.timeSlotDetail,
    this.discountCode,
    this.discountAmount,
    this.extraServices = const [],
    this.options = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      note: json['note'] as String?,
      notes: json['notes'] as String?,
      price: _parseDouble(json['price']),
      totalAmount: json['totalAmount'] as int?,
      status: json['status'] as String?,
      createdAt: _tryParseDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: _tryParseDate(json['updatedAt']) ?? DateTime.now(),
      address: json['address'] ?? '',
      emergencyRequest: json['emergencyRequest'] ?? false,

      // Additional fields
      userId: json['userId'] as String?,
      serviceType: json['serviceType'] as String?,
      customerFeedback: json['customerFeedback'] as String?,
      employeeRating: json['employeeRating'] as int?,
      bookingDate: _tryParseDate(json['bookingDate']),
      jobStartTime: _tryParseDate(json['jobStartTime']),
      jobEndTime: _tryParseDate(json['jobEndTime']),
      estimatedDuration: json['estimatedDuration'] as int?,
      actualDuration: json['actualDuration'] as int?,
      estimatedArrivalTime: _tryParseDate(json['estimatedArrivalTime']),
      cancellationDeadline: _tryParseDate(json['cancellationDeadline']),

      // New fields
      employeeId: json['employeeId'] as String?,
      cleaningToolsRequired: json['cleaningToolsRequired'] as String?,
      cleaningToolsProvided: json['cleaningToolsProvided'] as String?,
      distanceToCustomer: _parseDouble(json['distanceToCustomer']),
      priorityLevel: json['priorityLevel'] as String?,
      realTimeStatus: json['realTimeStatus'] as String?,
      cleaningAreas: json['cleaningAreas'] as String?,
      itemsToClean: json['itemsToClean'] as String?,
      timeSlotId: json['timeSlotId'] as String?,
      serviceId: json['serviceId'] as String?,
      timeSlotDetail: json['timeSlotDetail'] as String?,
      discountCode: json['discountCode'] as String?,
      discountAmount: _parseDouble(json['discountAmount']),

      extraServices: (json['extraServices'] as List<dynamic>? ?? [])
          .map((e) => ExtraService.fromJson(e as Map<String, dynamic>))
          .toList(),
      options: (json['options'] as List<dynamic>? ?? [])
          .map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Parse steps from note
  List<OrderStep> get steps {
    try {
      if (note == null || note!.isEmpty) return [];
      final decoded = jsonDecode(note!) as Map<String, dynamic>;
      final stepsList = decoded['Steps'] as List<dynamic>? ?? [];
      return stepsList.map((e) => OrderStep.fromJson(e)).toList();
    } catch (e) {
      print('Error parsing steps: $e');
      return [];
    }
  }

  // Helper method to safely parse dates
  static DateTime? _tryParseDate(dynamic dateStr) {
    if (dateStr == null) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  // Helper method to safely parse doubles
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
}

// Existing classes remain the same
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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      isMandatory: json['isMandatory'] ?? false,
    );
  }
}

class OrderStep {
  final String title;
  final String description;
  final String? time;
  final String status;
  final List<SubActivity> subActivities;

  OrderStep({
    required this.title,
    required this.description,
    this.time,
    required this.status,
    this.subActivities = const [],
  });

  factory OrderStep.fromJson(Map<String, dynamic> json) {
    return OrderStep(
      title: json['Title'] ?? '',
      description: json['Description'] ?? '',
      time: json['Time'],
      status: json['Status'] ?? '',
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
      activityId: json['ActivityId'] ?? '',
      title: json['Title'] ?? '',
      estimatedTime: json['EstimatedTime'] ?? '',
      status: json['Status'] ?? '',
    );
  }
}
