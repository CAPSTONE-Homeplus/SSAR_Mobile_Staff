import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/storage/hive_storage_service.dart';
import 'package:home_staff/infra/storage/storage_service.dart';
import 'package:home_staff/routing/router.dart';
import 'package:home_staff/theme/theme.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

// Create a provider for the initialized storage service
final initializedStorageProvider = Provider<StorageService>((ref) {
  // This should not be accessed during provider initialization
  throw UnimplementedError('Storage service must be initialized before use');
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the storage service
  final storageService = HiveStorageService();
  await storageService.init();

  // Create a provider container with the override
  final container = ProviderContainer(
    overrides: [
      // Override the localStorageServiceProvider with our initialized instance
      localStorageServiceProvider.overrideWithValue(storageService),
      // Also override our initialized provider
      initializedStorageProvider.overrideWithValue(storageService),
    ],
  );

  runApp(
    ProviderScope(
      parent: container,
      child: const TripFinder(),
    ),
  );
}

class TripFinder extends ConsumerWidget {
  const TripFinder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    SystemChrome.setSystemUIOverlayStyle(
      MediaQuery.of(context).platformBrightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    );

    return MaterialApp.router(
      title: 'Home Staff',
      debugShowCheckedModeBanner: false,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
    );
  }
}
