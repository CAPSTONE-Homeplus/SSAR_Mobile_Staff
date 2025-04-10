import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:home_staff/features/home/controller/home_controller.dart';
import 'package:home_staff/features/order_detail/view/order_detail_screen.dart';
import 'package:home_staff/shared/layout/app_scaffold.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/order_list_view.dart';
import 'widgets/profile_header.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeController = ref.read(homeControllerProvider.notifier);
    final homeState = ref.watch(homeControllerProvider);

    final checkedIn = useState(homeState.lastCheckIn != null);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    /// Lấy dữ liệu khi widget mount
    useEffect(() {
      Future.microtask(() async {
        await homeController.loadStaffProfile();
        await homeController.loadTasksOnly();

        if (homeState.lastCheckIn != null) {
          checkedIn.value = true;
          animationController.forward();
        }
      });
      return null;
    }, []);

    /// Refresh đơn hàng
    Future<void> refreshOrders() async {
      await homeController.loadTasksOnly();
    }

    /// Navigate chi tiết đơn hàng
    void navigateToOrderDetail(String orderId) {
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => OrderDetailScreen(orderId: orderId),
          ))
          .then((_) => refreshOrders());
    }

    return AppScaffold(
      body: homeState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  ProfileHeader(staffProfile: homeState.staffProfile),
                  Expanded(
                    child: OrderListView(
                      orders: homeState.staffOrders,
                      isLoading: homeState.isLoading,
                      errorMessage: homeState.errorMessage,
                      onRefresh: refreshOrders,
                      onOrderTapped: (order) => navigateToOrderDetail(order.id),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!checkedIn.value) {
            await homeController.checkIn();

            if (homeState.checkInError == null) {
              checkedIn.value = true;
              animationController.forward();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Bắt đầu làm việc')),
                );
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(homeState.checkInError ??
                        'Đã xảy ra lỗi khi bắt đầu làm việc'),
                  ),
                );
              }
            }
          } else {
            await homeController.checkOut();

            if (homeState.checkInError == null) {
              checkedIn.value = false;
              animationController.reverse();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('⛔ Đã dừng làm việc')),
                );
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(homeState.checkInError ??
                        'Đã xảy ra lỗi khi dừng làm việc'),
                  ),
                );
              }
            }
          }
        },
        icon: Icon(
          checkedIn.value ? Icons.stop_circle : Icons.login,
        ),
        label: Text(checkedIn.value ? 'DỪNG' : 'VÀO CA'),
        backgroundColor: checkedIn.value
            ? Colors.orange
            : Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
