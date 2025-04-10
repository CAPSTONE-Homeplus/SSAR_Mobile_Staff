import 'dart:async';

import 'package:dio/dio.dart';

/// Enum cho các loại HTTP method
enum RequestType { get, post, patch, put, delete }

/// Interface cho dịch vụ HTTP chung
abstract interface class HttpService {
  Future<void> init();

  Future<T> request<T>(
    BaseHttpRequest request, {
    required T Function(dynamic response) transformer,
  });
}

/// Lớp cơ sở cho mỗi HTTP request
abstract class BaseHttpRequest {
  /// URL gốc nếu muốn override baseUrl mặc định (tùy chọn)
  String? url;

  /// endpoint ví dụ: `/auth/login-staff`
  final String endpoint;

  /// HTTP method
  final RequestType type;

  /// Content-Type (mặc định là application/json)
  final String contentType;

  /// Getter để ghép full URL
  String get path {
    if (url != null) return url! + endpoint;
    return endpoint;
  }

  BaseHttpRequest({
    required this.endpoint,
    this.type = RequestType.get,
    this.url,
    this.contentType = Headers.jsonContentType,
  });

  /// Trả về dữ liệu cần truyền lên (query hoặc body)
  FutureOr<Map<String, dynamic>> toMap();
}
