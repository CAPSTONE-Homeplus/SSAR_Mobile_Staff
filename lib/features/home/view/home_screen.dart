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

    /// Lấy dữ liệu khi widget mount
    useEffect(() {
      Future.microtask(() async {
        await homeController.loadStaffProfile();
        await homeController.loadTasksOnly();
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

    /// Xử lý check-in
    Future<void> handleCheckIn() async {
      await homeController.checkIn();

      if (homeState.checkInError == null) {
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
    }

    /// Xử lý check-out
    Future<void> handleCheckOut() async {
      await homeController.checkOut();

      if (homeState.checkInError == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⛔ Đã dừng làm việc')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  homeState.checkInError ?? 'Đã xảy ra lỗi khi dừng làm việc'),
            ),
          );
        }
      }
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
      floatingActionButton: Builder(
        builder: (context) {
          if (homeState.staffStatus == 'Offline') {
            return FloatingActionButton.extended(
              onPressed: handleCheckIn,
              icon: const Icon(Icons.login),
              label: const Text('VÀO CA'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            );
          } else if (homeState.staffStatus == 'Ready') {
            return FloatingActionButton.extended(
              onPressed: handleCheckOut,
              icon: const Icon(Icons.stop_circle),
              label: const Text('DỪNG'),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            );
          } else {
            // Trường hợp không xác định hoặc trạng thái khác
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
