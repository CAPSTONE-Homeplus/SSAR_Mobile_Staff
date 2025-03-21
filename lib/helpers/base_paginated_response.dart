import 'package:equatable/equatable.dart';

class BasePaginatedResponse<T> extends Equatable {
  final int size;
  final int page;
  final int total;
  final int totalPages;
  final List<T> items;

  const BasePaginatedResponse({
    required this.size,
    required this.page,
    required this.total,
    required this.totalPages,
    required this.items,
  });

  factory BasePaginatedResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return BasePaginatedResponse(
      size: json["size"] ?? 0,
      page: json["page"] ?? 0,
      total: json["total"] ?? 0,
      totalPages: json["totalPages"] ?? 0,
      items: (json["items"] as List<dynamic>)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [size, page, total, totalPages, items];
}
