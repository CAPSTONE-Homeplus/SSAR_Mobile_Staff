import 'package:home_staff/constants/enums.dart';
import 'package:home_staff/features/splash/controller/splash_controller.dart';
import 'package:home_staff/gen/assets.gen.dart';
import 'package:home_staff/helpers/logger.dart';
import 'package:home_staff/infra/lifecycle/lifecycle_provider.dart';
import 'package:home_staff/routing/router.dart';
import 'package:home_staff/theme/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashControllerProvider, (previous, next) {
      if (next.hasValue) {
        Future.delayed(const Duration(seconds: 1), () {
          final value = next.requireValue;

          /// Delay routing 1 second, so that the logo is seen
          GoRouter.of(context).go(RoutePaths.login);
        });
      }
      if (next.hasError) {
        logger.info('Error in splash page ${next.error}');
        debugPrintStack(stackTrace: next.stackTrace!);
      }
    });

    return Scaffold(
        body: Center(
      child: Hero(
        tag: HeroAnimationTags.splashLogo,
        child: AppIcons.icon(
          Assets.icons.earthPlane,
          size: 80,
          color: Theme.of(context).primaryColor,
        ),
      ),
    ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(lifeCycleControllerProvider.notifier).updateState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
