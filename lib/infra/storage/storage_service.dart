import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/storage/hive_storage_service.dart';

/// Static class for defining keys for storing values
class LocalStorageKeys {}

final localStorageServiceProvider = Provider<StorageService>(
  (_) => HiveStorageService(),
);

/// Abstract class defining [StorageService] structure
abstract class StorageService {
  Future<void> init();

  /// Delete value by key
  Future<void> deleteValue(String key);

  /// Get value by key
  String? getValue(String key);

  /// Clear storage
  Future<void> clear();

  /// Store new value
  Future<void> setValue({required String key, required String? data});
}
