import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/storage/hive_storage_service.dart';
import 'package:home_staff/infra/storage/storage_service.dart';

final storageServiceProvider =
    Provider<StorageService>((ref) => HiveStorageService());

final activeOrderStorageProvider = Provider<ActiveOrderStorage>((ref) {
  return ActiveOrderStorage(ref);
});

class ActiveOrderStorage {
  static const String _activeOrderKey = 'active_order_id';
  final Ref ref;
  ActiveOrderStorage(this.ref);

  /// Save active order ID to storage
  Future<void> saveActiveOrderId(String orderId) async {
    final storageService = ref.read(storageServiceProvider);

    // Save the order ID directly as a string value
    await storageService.setValue(key: _activeOrderKey, data: orderId);
  }

  /// Get the active order ID, returns null if not present
  Future<String?> getActiveOrderId() async {
    final storageService = ref.read(storageServiceProvider);

    // Get the string value directly
    return storageService.getValue(_activeOrderKey);
  }

  /// Remove the active order ID from storage
  Future<void> removeActiveOrderId() async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.deleteValue(_activeOrderKey);
  }

  /// Check if there is an active order
  Future<bool> hasActiveOrder() async {
    final orderId = await getActiveOrderId();
    return orderId != null && orderId.isNotEmpty;
  }
}
