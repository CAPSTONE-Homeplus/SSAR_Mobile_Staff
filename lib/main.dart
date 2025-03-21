import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/infra/storage/hive_storage_service.dart';
import 'package:home_staff/routing/router.dart';
import 'package:home_staff/theme/theme.dart';

// 🔹 Provider để quản lý trạng thái ngôn ngữ
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

Future<void> main() async {
  await _prepareApp();

  runApp(
    const ProviderScope(
      child: TripFinder(),
    ),
  );
}

Future<void> _prepareApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = HiveStorageService();
  await storageService.init();
  // Load environment variables from .env file
  // await dotenv.load();
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
      title: 'Trip Finder',
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
