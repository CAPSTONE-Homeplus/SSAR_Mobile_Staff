import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../storage/hive_storage_service.dart';
import '../storage/storage_service.dart';
import 'http_service.dart';

final tokenProvider = FutureProvider<String>((ref) async {
  final storage = ref.read(localStorageServiceProvider);
  final Map<String, dynamic>? userStorage = storage.getObject(
    'user',
    (json) => json,
  );

  if (userStorage == null || userStorage["accessToken"] == null) {
    throw Exception("Không tìm thấy accessToken");
  }

  return userStorage["accessToken"];
});

final class DioHttpService implements HttpService {
  final ProviderRef ref;
  final Dio dio = Dio();
  final Logger logger = Logger();

  DioHttpService(this.ref);

  @override
  Future<void> init() async {
    dio.interceptors.clear();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final isPublic = _isPublicEndpoint(options.path);
            if (!isPublic) {
              final token = await ref.refresh(tokenProvider.future);
              if (token.isNotEmpty) {
                options.headers["Authorization"] = "Bearer $token";
              }
            }
          } catch (e) {
            logger.w("Không có token hoặc lỗi khi đọc token: $e");
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          try {
            if (response.data is String) {
              response.data = jsonDecode(response.data);
            }
            response.data ??= <String, dynamic>{};
          } catch (e) {
            logger.w("Lỗi decode JSON: $e");
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          logger.e("HTTP Error: ${error.message}", error: error);
          return handler.next(error);
        },
      ),
    );
  }

  bool _isPublicEndpoint(String path) {
    final lower = path.toLowerCase();
    return lower.contains("/auth/login") || lower.contains("/auth/register");
  }

  @override
  Future<T> request<T>(
    BaseHttpRequest request, {
    required T Function(dynamic response) transformer,
  }) async {
    dynamic value;

    request.url ??= "";

    switch (request.type) {
      case RequestType.get:
        value = await _get(request);
        break;
      case RequestType.post:
        value = await _post(request);
        break;
      case RequestType.patch:
        value = await _patch(request);
        break;
      case RequestType.put:
        value = await _put(request);
        break;
      case RequestType.delete:
        value = await _delete(request);
        break;
    }

    return transformer(value);
  }

  Future<dynamic> _get(BaseHttpRequest request) async {
    final resp = await dio.get(
      request.path,
      queryParameters: request.queryParameters ?? await request.toMap(),
      options: Options(contentType: request.contentType),
    );
    return resp.data;
  }

  Future<dynamic> _post(BaseHttpRequest request) async {
    final resp = await dio.post(
      request.path,
      data: await request.toMap(),
      queryParameters: request.queryParameters,
      options: Options(contentType: request.contentType),
    );
    return resp.data;
  }

  Future<dynamic> _put(BaseHttpRequest request) async {
    final resp = await dio.put(
      request.path,
      data: await request.toMap(),
      queryParameters: request.queryParameters,
      options: Options(contentType: request.contentType),
    );
    return resp.data;
  }

  Future<dynamic> _patch(BaseHttpRequest request) async {
    final resp = await dio.patch(
      request.path,
      data: await request.toMap(),
      queryParameters: request.queryParameters,
      options: Options(contentType: request.contentType),
    );
    return resp.data;
  }

  Future<dynamic> _delete(BaseHttpRequest request) async {
    final resp = await dio.delete(
      request.path,
      data: await request.toMap(),
      queryParameters: request.queryParameters,
      options: Options(contentType: request.contentType),
    );
    return resp.data;
  }
}

final httpServiceProvider = Provider<HttpService>((ref) {
  final service = DioHttpService(ref);
  unawaited(service.init());
  return service;
});
