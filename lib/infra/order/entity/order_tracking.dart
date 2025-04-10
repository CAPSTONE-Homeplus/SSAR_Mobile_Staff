class OrderTracking {
  final String orderId;
  final String status;
  final String message;
  final DateTime timestamp;
  final Map<String, dynamic>? additionalData;

  OrderTracking({
    required this.orderId,
    required this.status,
    required this.message,
    required this.timestamp,
    this.additionalData,
  });

  /// Creates an OrderTracking instance from a JSON map.
  /// Used for direct JSON parsing without wrapper.
  factory OrderTracking.fromJson(Map<String, dynamic> json) {
    return OrderTracking(
      orderId: json['orderId'] ?? '',
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      additionalData: json['additionalData'],
    );
  }

  /// Creates an OrderTracking instance from SignalR data.
  /// Used when parsing from SignalR wrapper with Type and Data fields.
  factory OrderTracking.fromJsonSignalR(Map<String, dynamic> json) {
    return OrderTracking(
      orderId: json['orderId'] ?? json['OrderId'] ?? '',
      status: json['status'] ?? json['Status'] ?? '',
      message: json['message'] ?? json['Message'] ?? '',
      timestamp: _parseDateTime(json['timestamp'] ?? json['Timestamp']),
      additionalData: json['additionalData'] ?? json['AdditionalData'],
    );
  }

  /// Helper method to parse DateTime from various formats
  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();

    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (_) {
        // If parsing fails, return current time
        return DateTime.now();
      }
    }

    return DateTime.now();
  }

  /// Converts the OrderTracking instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'status': status,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'additionalData': additionalData,
    };
  }

  @override
  String toString() {
    return 'OrderTracking{orderId: $orderId, status: $status, message: $message, timestamp: $timestamp}';
  }
}
