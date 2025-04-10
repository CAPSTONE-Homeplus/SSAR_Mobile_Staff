// 📦 Model: OrderTrackingSignalR (tách riêng từ SignalR)

class OrderTrackingSignalR {
  final String orderId;
  final Map<String, dynamic>? note;
  final DateTime? createdAt;

  OrderTrackingSignalR({
    required this.orderId,
    this.note,
    this.createdAt,
  });

  factory OrderTrackingSignalR.fromJson(Map<String, dynamic> json) {
    // Log toàn bộ JSON để debug
    print('Raw JSON: $json');

    // Thử nhiều trường khác nhau có thể chứa ngày tháng
    DateTime? createdAt;

    // Cách 1: Trực tiếp từ trường createdAt hoặc tương tự
    if (json['CreatedAt'] != null) {
      try {
        createdAt = DateTime.parse(json['CreatedAt']);
      } catch (e) {
        print('Không thể parse CreatedAt: ${json['CreatedAt']}');
      }
    }

    // Cách 2: Từ trường Time nếu có
    if (createdAt == null && json['Time'] != null) {
      try {
        createdAt = DateTime.parse(json['Time']);
      } catch (e) {
        print('Không thể parse Time: ${json['Time']}');
      }
    }

    // Cách 3: Nếu có trường Date riêng
    if (createdAt == null && json['Date'] != null) {
      try {
        createdAt = DateTime.parse(json['Date']);
      } catch (e) {
        print('Không thể parse Date: ${json['Date']}');
      }
    }

    return OrderTrackingSignalR(
      orderId: json['Id'] ?? '',
      // thêm các trường khác nếu cần
      createdAt: createdAt,
    );
  }
}
