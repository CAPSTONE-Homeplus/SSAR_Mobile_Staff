import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:home_staff/features/home/controller/home_controller.dart';
import 'package:home_staff/features/home/controller/home_state.dart';
import 'package:home_staff/infra/staff/entity/staff_entity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/attendance_card.dart';
import 'widgets/profile_header.dart';
import 'widgets/service_type_filter.dart';
import 'widgets/task_list.dart';
import 'widgets/custom_bottom_nav.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeController = ref.read(homeControllerProvider.notifier);
    final homeState = ref.watch(homeControllerProvider);

    final checkedIn = useState(false);
    final selectedServiceType = useState('all');
    final checkInTime = useState<DateTime?>(null);

    // Animation controller for check-in success
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    // Initialize the screen
    useEffect(() {
      homeController.loadStaffProfile();
      homeController.loadTasks();

      // Check if already checked in today
      final lastCheckIn = homeController.getLastCheckIn();
      if (lastCheckIn != null) {
        final today = DateTime.now();
        if (lastCheckIn.year == today.year &&
            lastCheckIn.month == today.month &&
            lastCheckIn.day == today.day) {
          checkedIn.value = true;
          checkInTime.value = lastCheckIn;
        }
      }

      return null;
    }, []);

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: homeState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  // Header section with profile
                  ProfileHeader(
                    staffProfile: homeState.staffProfile,
                  ),

                  // Attendance Card
                  AttendanceCard(
                    checkedIn: checkedIn,
                    checkInTime: checkInTime,
                    animationController: animationController,
                    homeController: homeController,
                    homeState: homeState,
                  ),

                  // Service type filter
                  ServiceTypeFilter(
                    selectedServiceType: selectedServiceType,
                  ),

                  // Tasks section
                  Expanded(
                    child: TaskList(
                      tasks: homeState.tasks,
                      selectedServiceType: selectedServiceType.value,
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              // Already on Home
              break;
            case 1:
              // context.push(RoutePaths.schedule);
              break;
            case 2:
              // context.push(RoutePaths.history);
              break;
            case 3:
              // context.push(RoutePaths.profile);
              break;
          }
        },
      ),
    );
  }
}

// Helper class for colors
class AppColors {
  static const Color primaryColor = Color(0xFF1E88E5);
  static const Color accentColor = Color(0xFF26A69A);
  static const Color backgroundGrey = Color(0xFFF5F7FA);
}
