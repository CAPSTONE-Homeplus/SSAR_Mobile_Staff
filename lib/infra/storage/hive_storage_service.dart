import 'dart:convert';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_staff/infra/storage/storage_service.dart';

/// Implementation of [StorageService] with [Hive]
final class HiveStorageService extends StorageService {
  late Box<dynamic> hiveBox;

  @override
  Future<void> init() async {
    if (Platform.isAndroid || Platform.isIOS) await Hive.initFlutter();

    return _openBox('box');
  }

  Future<void> _openBox(String boxName) async {
    hiveBox = await Hive.openBox(boxName);
  }

  Future<void> closeBox() async => hiveBox.close();

  @override
  Future<void> deleteValue(String key) async => hiveBox.delete(key);

  @override
  String? getValue(String key) => hiveBox.get(key) as String?;

  @override
  Future<void> setValue({required String key, required String? data}) async =>
      hiveBox.put(key, data);

  @override
  Future<void> clear() async => hiveBox.clear();
}

extension HiveStorageExtension on StorageService {
  Future<void> setObject<T>({required String key, required T data}) async {
    final jsonData = jsonEncode(data);
    await setValue(key: key, data: jsonData);
  }

  T? getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final jsonString = getValue(key);
    if (jsonString == null) return null;
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return fromJson(jsonMap);
  }
}
