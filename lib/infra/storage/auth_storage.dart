import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/storage/hive_storage_service.dart';
import 'package:home_staff/infra/storage/storage_service.dart';

final storageServiceProvider =
    Provider<StorageService>((ref) => HiveStorageService());

class AuthStore {
  final WidgetRef ref;

  AuthStore(this.ref);

  Future<String> getAccessToken() async {
    // Get the StorageService using ref
    final storageService = ref.read(storageServiceProvider);

    final userStorage =
        storageService.getObject<Map<String, dynamic>>('user', (json) => json);

    if (userStorage == null || userStorage["accessToken"] == null) {
      throw Exception("No access token found");
    }

    return userStorage["accessToken"];
  }
}
