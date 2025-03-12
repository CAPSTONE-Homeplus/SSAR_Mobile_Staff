import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:home_staff/routing/router.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final homeController = ref.watch(homeControllerProvider.notifier);
    final homeState = ref.watch(homeControllerProvider);
    final checkedIn = useState(false);
    final selectedServiceType = useState('all');

    // Animation controller for check-in success
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    final checkInTime = useState<DateTime?>(null);

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
            // Header section with profile and check-in
            _buildHeader(context, homeState.staffProfile, checkedIn, checkInTime, animationController),

            // Service type filter
            _buildServiceTypeFilter(context, selectedServiceType),

            // Tasks section
            Expanded(
              child: _buildTasksList(
                  context,
                  homeState.tasks,
                  selectedServiceType.value,
                  localizations
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, 0),
    );
  }

  Widget _buildHeader(
      BuildContext context,
      StaffProfile? profile,
      ValueNotifier<bool> checkedIn,
      ValueNotifier<DateTime?> checkInTime,
      AnimationController animationController,
      ) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    final localizations = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? localizations.goodMorning
        : now.hour < 17
        ? localizations.goodAfternoon
        : localizations.goodEvening;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profile avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    profile?.name.isNotEmpty == true
                        ? profile!.name[0].toUpperCase()
                        : "S",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Profile info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$greeting, ${profile?.name ?? 'Staff'}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile?.serviceType == 'cleaning'
                          ? localizations.cleaningSpecialist
                          : profile?.serviceType == 'laundry'
                          ? localizations.laundrySpecialist
                          : localizations.staffMember,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Notifications icon
              IconButton(
                onPressed: () {
                  // TODO: Navigate to notifications
                },
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_outlined, size: 28),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: const Text(
                          '2',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Check-in card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizations.dailyAttendance,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DateFormat('EEEE, d MMMM').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                checkedIn.value
                    ? Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[600],
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.checkedInAt,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          checkInTime.value != null
                              ? DateFormat.jm().format(checkInTime.value!)
                              : DateFormat.jm().format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        localizations.present,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.youHaventCheckedInToday,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle check-in logic
                          checkedIn.value = true;
                          checkInTime.value = DateTime.now();
                          animationController.forward();

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizations.checkInSuccessful),
                              backgroundColor: Colors.green[600],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(localizations.checkIn),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Check-in success animation
          if (checkedIn.value)
            FadeTransition(
              opacity: animation,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                child: Text(
                  localizations.readyForService,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeFilter(
      BuildContext context,
      ValueNotifier<String> selectedServiceType,
      ) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildFilterChip(
            context,
            localizations.all,
            'all',
            selectedServiceType,
            Icons.list_alt_rounded,
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            context,
            localizations.cleaning,
            'cleaning',
            selectedServiceType,
            Icons.cleaning_services_rounded,
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            context,
            localizations.laundry,
            'laundry',
            selectedServiceType,
            Icons.local_laundry_service_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context,
      String label,
      String value,
      ValueNotifier<String> selectedValue,
      IconData icon,
      ) {
    final isSelected = selectedValue.value == value;

    return Expanded(
      child: InkWell(
        onTap: () {
          selectedValue.value = value;
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksList(
      BuildContext context,
      List<Task> tasks,
      String filterType,
      AppLocalizations localizations,
      ) {
    // Filter tasks based on selected service type
    final filteredTasks = filterType == 'all'
        ? tasks
        : tasks.where((task) => task.serviceType == filterType).toList();

    return filteredTasks.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            localizations.noTasksAvailable,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            filterType == 'all'
                ? localizations.checkBackLater
                : localizations.noTasksForSelectedType,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return _buildTaskCard(context, task, localizations);
      },
    );
  }

  Widget _buildTaskCard(
      BuildContext context,
      Task task,
      AppLocalizations localizations,
      ) {
    final serviceColor = task.serviceType == 'cleaning'
        ? Colors.blue
        : Colors.purple;

    final statusColor = task.status == 'pending'
        ? Colors.orange
        : task.status == 'in_progress'
        ? Colors.blue
        : task.status == 'completed'
        ? Colors.green
        : Colors.grey;

    final statusText = task.status == 'pending'
        ? localizations.pending
        : task.status == 'in_progress'
        ? localizations.inProgress
        : task.status == 'completed'
        ? localizations.completed
        : localizations.unknown;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to task detail
          // context.push('${RoutePaths.taskDetail}/${task.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task header with time and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        task.serviceType == 'cleaning'
                            ? Icons.cleaning_services_rounded
                            : Icons.local_laundry_service_rounded,
                        color: serviceColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        task.serviceType == 'cleaning'
                            ? localizations.cleaning
                            : localizations.laundry,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: serviceColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),

              // Task details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Apartment info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.apartmentInfo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.location,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          task.apartmentType,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Time info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.scheduledFor,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMM d').format(task.scheduledTime),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('h:mm a').format(task.scheduledTime),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: task.status == 'pending'
                      ? () {
                    // Start task
                    // context.push('${RoutePaths.taskDetail}/${task.id}');
                  }
                      : task.status == 'in_progress'
                      ? () {
                    // Complete task
                    // context.push('${RoutePaths.taskDetail}/${task.id}');
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: task.status == 'completed'
                        ? Colors.grey[200]
                        : Theme.of(context).primaryColor,
                    foregroundColor: task.status == 'completed'
                        ? Colors.grey[700]
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    task.status == 'pending'
                        ? localizations.startTask
                        : task.status == 'in_progress'
                        ? localizations.completeTask
                        : localizations.viewDetails,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                Icons.home_filled,
                localizations.home,
                isSelected: currentIndex == 0,
                onTap: () {
                  // Already on home
                },
              ),
              _buildNavItem(
                context,
                Icons.calendar_month,
                localizations.schedule,
                isSelected: currentIndex == 1,
                onTap: () {
                  // context.push(RoutePaths.schedule);
                },
              ),
              _buildNavItem(
                context,
                Icons.history,
                localizations.history,
                isSelected: currentIndex == 2,
                onTap: () {
                  // context.push(RoutePaths.history);
                },
              ),
              _buildNavItem(
                context,
                Icons.person,
                localizations.profile,
                isSelected: currentIndex == 3,
                onTap: () {
                  // context.push(RoutePaths.profile);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context,
      IconData icon,
      String label,
      {required bool isSelected, required VoidCallback onTap}
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mock classes for demonstration
class StaffProfile {
  final String id;
  final String name;
  final String phoneNumber;
  final String serviceType; // 'cleaning', 'laundry', or 'both'
  final int completedTasks;
  final double rating;

  StaffProfile({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.serviceType,
    required this.completedTasks,
    required this.rating,
  });
}

class Task {
  final String id;
  final String serviceType; // 'cleaning' or 'laundry'
  final String location;
  final String apartmentType;
  final DateTime scheduledTime;
  final String status; // 'pending', 'in_progress', 'completed', 'cancelled'
  final String customerName;

  Task({
    required this.id,
    required this.serviceType,
    required this.location,
    required this.apartmentType,
    required this.scheduledTime,
    required this.status,
    required this.customerName,
  });
}

// Mock providers
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController();
});

class HomeController extends StateNotifier<HomeState> {
  HomeController() : super(HomeState(isLoading: true));

  Future<void> loadStaffProfile() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final profile = StaffProfile(
      id: '12345',
      name: 'Nguyễn Văn A',
      phoneNumber: '0912345678',
      serviceType: 'cleaning', // or 'laundry'
      completedTasks: 127,
      rating: 4.8,
    );

    state = state.copyWith(
      staffProfile: profile,
      isLoading: false,
    );
  }

  Future<void> loadTasks() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();
    final tasks = [
      Task(
        id: 't1',
        serviceType: 'cleaning',
        location: 'Rainbow S1.02 - #2312',
        apartmentType: '2 Bedroom Apartment',
        scheduledTime: DateTime(now.year, now.month, now.day, 10, 30),
        status: 'pending',
        customerName: 'Trần Thị B',
      ),
      Task(
        id: 't2',
        serviceType: 'laundry',
        location: 'Masteri Home A3 - #1204',
        apartmentType: 'Studio Apartment',
        scheduledTime: DateTime(now.year, now.month, now.day, 13, 0),
        status: 'pending',
        customerName: 'Lê Văn C',
      ),
      Task(
        id: 't3',
        serviceType: 'cleaning',
        location: 'Origami S2.05 - #1507',
        apartmentType: '1 Bedroom Apartment',
        scheduledTime: DateTime(now.year, now.month, now.day, 15, 30),
        status: 'in_progress',
        customerName: 'Phạm Thị D',
      ),
    ];

    state = state.copyWith(
      tasks: tasks,
      isLoading: false,
    );
  }

  DateTime? getLastCheckIn() {
    // In a real app, this would come from shared preferences or local storage
    return null; // Return null to simulate no check-in today
  }
}

class HomeState {
  final bool isLoading;
  final StaffProfile? staffProfile;
  final List<Task> tasks;

  HomeState({
    required this.isLoading,
    this.staffProfile,
    this.tasks = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    StaffProfile? staffProfile,
    List<Task>? tasks,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      staffProfile: staffProfile ?? this.staffProfile,
      tasks: tasks ?? this.tasks,
    );
  }
}

// Helper class for colors
class AppColors {
  static const Color primaryColor = Color(0xFF1E88E5);
  static const Color accentColor = Color(0xFF26A69A);
  static const Color backgroundGrey = Color(0xFFF5F7FA);
}