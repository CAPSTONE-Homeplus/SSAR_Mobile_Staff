import 'package:home_staff/constants/enums.dart';
import 'package:home_staff/features/onboarding/widgets/onboarding_page_view.dart';
import 'package:home_staff/features/onboarding/widgets/page_indicator.dart';
import 'package:home_staff/gen/assets.gen.dart';
import 'package:home_staff/helpers/helper_extensions.dart';
import 'package:home_staff/theme/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:home_staff/features/shared/buttons/primary_button.dart';
import 'package:home_staff/features/onboarding/controllers/onboarding_controller.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(onboardingControllerProvider.notifier);
    final state = ref.watch(onboardingControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Hero(
                  tag: HeroAnimationTags.splashLogo,
                  child: AppIcons.icon(
                    Assets.icons.earthPlane,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 400,
                        child: PageView(
                          controller: controller.pageController,
                          onPageChanged: (newPage) => controller.updateCurrentPage(newPage),
                          children: [
                            OnboardingPageView(
                              imagePath: Assets.images.socialSharing,
                              text: context.localization.onboardingShare,
                            ),
                            OnboardingPageView(
                              imagePath: Assets.images.teamCollaboration,
                              text: context.localization.onboardingCollaborate,
                            ),
                            OnboardingPageView(
                              imagePath: Assets.images.travelling,
                              text: context.localization.onboardingTravel,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PageIndicator(currentPageIndex: state.currentPage, totalPageNumber: 3),
                const SizedBox(height: 16),
                Container(
                  height: 48,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: PrimaryButton(
                    text: context.localization.getStarted,
                    onPressed: () => controller.onPressStart(context),
                    isDisabled: !state.onboardingFinished,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
