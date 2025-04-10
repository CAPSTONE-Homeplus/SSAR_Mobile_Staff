import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:home_staff/features/history/controller/history_controller.dart';
import 'package:home_staff/features/home/view/widgets/profile_header.dart';
import 'package:home_staff/features/order_detail/view/order_detail_screen.dart';
import 'package:home_staff/shared/layout/app_scaffold.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/order_list_view.dart';

class HistoryScreen extends HookConsumerWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(historyControllerProvider.notifier);
    final state = ref.watch(historyControllerProvider);

    useEffect(() {
      Future.microtask(() => controller.loadHistory());
      return null;
    }, []);

    void _onOrderTapped(String orderId) {
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => OrderDetailScreen(orderId: orderId),
          ))
          .then((_) => controller.refreshOrders());
    }

    return AppScaffold(
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  ProfileHeader(staffProfile: state.staffProfile),
                  Expanded(
                    child: HistoryOrderListView(
                      orders: state.staffOrders,
                      isLoading: state.isLoading,
                      errorMessage: state.errorMessage,
                      onRefresh: controller.refreshOrders,
                      onOrderTapped: (order) => _onOrderTapped(order.id),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
