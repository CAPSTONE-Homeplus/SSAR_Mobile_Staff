import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:home_staff/features/home/controller/home_controller.dart';
import 'package:home_staff/features/home/controller/home_state.dart';
import 'package:intl/intl.dart';

class AttendanceCard extends StatelessWidget {
  final ValueNotifier<bool> checkedIn;
  final ValueNotifier<DateTime?> checkInTime;
  final AnimationController animationController;
  final HomeController homeController;
  final HomeState homeState;

  const AttendanceCard({
    Key? key,
    required this.checkedIn,
    required this.checkInTime,
    required this.animationController,
    required this.homeController,
    required this.homeState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
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
                    ? _buildCheckedInView(context, localizations)
                    : _buildNotCheckedInView(context, localizations),
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

  Widget _buildCheckedInView(
      BuildContext context, AppLocalizations localizations) {
    return Row(
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
    );
  }

  Widget _buildNotCheckedInView(
      BuildContext context, AppLocalizations localizations) {
    return Column(
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
            onPressed: () async {
              await homeController.checkIn();

              if (homeState.checkInError == null) {
                checkedIn.value = true;
                checkInTime.value = DateTime.now();
                animationController.forward();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizations.checkInSuccessful),
                    backgroundColor: Colors.green[600],
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(homeState.checkInError ?? "Lỗi check-in"),
                    backgroundColor: Colors.red[600],
                  ),
                );
              }
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
    );
  }
}
