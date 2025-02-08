import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean_crew/app_router.dart';
import 'package:home_clean_crew/data/repositories/auth/authentication_repository_impl.dart';
import 'package:home_clean_crew/data/repositories/notification/notification_repository.dart';
import 'package:home_clean_crew/data/repositories/notification/notification_repository_impl.dart';
import 'package:home_clean_crew/data/repositories/time_slot/time_slot_repository.dart';
import 'package:home_clean_crew/data/repositories/time_slot/time_slot_repository_impl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/auth/authentication_repository.dart';
import 'domain/usecases/notification/initialize_notification_usecase.dart';
import 'domain/usecases/notification/show_notification_usecase.dart';
import 'presentation/blocs/authentication/authentication_bloc.dart';
import 'presentation/blocs/internet/internet_bloc.dart';
import 'presentation/blocs/theme/theme_bloc.dart';

final sl = GetIt.instance;
final navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
late InitializeNotificationUseCase _initializeNotificationUseCase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await setupServiceLocator();

  _initializeNotificationUseCase = InitializeNotificationUseCase(sl());
  await _initializeNotificationUseCase.call();

  await initializeDateFormatting('vi_VN', null);

  runApp(HomeCleanCrew(preferences: sl<SharedPreferences>()));
}

Future<void> setupServiceLocator() async {
  // Service
  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // LocalDataSources

  // Repositories (sử dụng LazySingleton vì chúng ta muốn tái sử dụng đối tượng)
  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl());
  sl.registerLazySingleton<TimeSlotRepository>(() => TimeSlotRepositoryImpl());
  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton(() => InitializeNotificationUseCase(sl()));
  sl.registerLazySingleton(() => ShowNotificationUseCase(sl()));

  // Blocs (sử dụng Factory vì mỗi bloc sẽ cần một instance mới)
  sl.registerFactory(() => AuthenticationBloc(authenticationRepository: sl()));
  sl.registerFactory(() => InternetBloc());
  sl.registerFactory(() => ThemeBloc(preferences: sl()));
}

class HomeCleanCrew extends StatelessWidget {
  final SharedPreferences preferences;

  const HomeCleanCrew({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
            create: (_) => sl<AuthenticationRepository>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => InternetBloc()),
          BlocProvider(
              create: (context) => ThemeBloc(preferences: preferences)),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            ThemeData themeData = ThemeData.light();

            if (state is ThemeInitial) {
              themeData = state.themeData;
            }

            return GetMaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Home Clean Crew',
              theme: themeData.copyWith(
                textTheme: GoogleFonts.notoSansTextTheme(themeData.textTheme),
              ),
              getPages: AppRouter.routes,
              initialRoute: AppRouter.routeSplash,
            );
          },
        ),
      ),
    );
  }
}
