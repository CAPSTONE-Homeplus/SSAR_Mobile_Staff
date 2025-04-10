import 'package:flutter/material.dart';
import 'package:home_staff/features/order_detail/view/order_detail_screen.dart';
import 'package:home_staff/infra/staff/entity/staff_order_entity.dart';

import './order_card.dart';
import './order_list_placeholder.dart';

class OrderListView extends StatelessWidget {
  final List<Order> orders;
  final Function(Order)? onOrderTapped;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRefresh;

  const OrderListView({
    Key? key,
    required this.orders,
    this.onOrderTapped,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeOrders = orders.where((order) {
      final status = order.status?.toLowerCase().trim();
      return status == "accepted" || status == "inprogress";
    }).toList();

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return OrderListPlaceholder(
        icon: Icons.error_outline,
        message: errorMessage!,
        onRetry: onRefresh,
      );
    }

    if (activeOrders.isEmpty) {
      return OrderListPlaceholder(
        icon: Icons.assignment_outlined,
        message: "Không có đơn hàng cần xử lý.",
        onRetry: onRefresh,
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh?.call(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: activeOrders.length,
        itemBuilder: (context, index) {
          final order = activeOrders[index];
          return OrderCard(
            order: order,
            onTap: onOrderTapped != null
                ? () => onOrderTapped!(order)
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailScreen(orderId: order.id),
                      ),
                    ),
          );
        },
      ),
    );
  }
}

class HistoryOrderListView extends StatelessWidget {
  final List<Order> orders;
  final Function(Order)? onOrderTapped;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRefresh;

  const HistoryOrderListView({
    Key? key,
    required this.orders,
    this.onOrderTapped,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final historyOrders = orders.where((order) {
      final status = order.status?.toLowerCase().trim();
      return status != "accepted" && status != "inprogress";
    }).toList();

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return OrderListPlaceholder(
        icon: Icons.error_outline,
        message: errorMessage!,
        onRetry: onRefresh,
      );
    }

    if (historyOrders.isEmpty) {
      return OrderListPlaceholder(
        icon: Icons.history,
        message: "Chưa có đơn hàng nào trong lịch sử.",
        onRetry: onRefresh,
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh?.call(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: historyOrders.length,
        itemBuilder: (context, index) {
          final order = historyOrders[index];
          return OrderCard(
            order: order,
            onTap: onOrderTapped != null
                ? () => onOrderTapped!(order)
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailScreen(orderId: order.id),
                      ),
                    ),
          );
        },
      ),
    );
  }
}
