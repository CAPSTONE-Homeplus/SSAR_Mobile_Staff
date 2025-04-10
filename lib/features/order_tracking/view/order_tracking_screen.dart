import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/features/order_tracking/controllers/order_tracking_controller.dart';
import 'package:home_staff/features/order_tracking/view/widgets/checkout_fab.dart';
import 'package:home_staff/features/order_tracking/view/widgets/error_view.dart';
import 'package:home_staff/features/order_tracking/view/widgets/progress_overview_card.dart';
import 'package:home_staff/features/order_tracking/view/widgets/work_activities_card.dart';

class OrderTrackingScreen extends ConsumerWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderTrackingControllerProvider(orderId));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Theo dõi tiến độ',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 1,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh),
        //     onPressed: () => ref
        //         .read(orderTrackingControllerProvider(orderId).notifier)
        //         .fetchOrderSteps(),
        //     tooltip: 'Làm mới',
        //   ),
        // ],
      ),
      body: _buildBody(context, ref, state),
      floatingActionButton:
          CheckoutFloatingButton(orderId: orderId, steps: state.steps),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(
      BuildContext context, WidgetRef ref, OrderTrackingState state) {
    final textTheme = Theme.of(context).textTheme;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError) {
      return ErrorView(
        errorMessage: state.errorMessage!,
        orderId: orderId,
        ref: ref,
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: ProgressOverviewCard(steps: state.steps),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: WorkActivitiesCard(
              step: state.stepWithActivities,
              orderId: orderId,
            ),
          ),
        ),

        // SliverToBoxAdapter(
        //   child: Padding(
        //     padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        //     child: Text(
        //       'Tất cả các bước',
        //       style: textTheme.titleMedium?.copyWith(
        //         fontWeight: FontWeight.w600,
        //       ),
        //     ),
        //   ),
        // ),
        //
        // SliverPadding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   sliver: SliverList(
        //     delegate: SliverChildBuilderDelegate(
        //       (context, index) {
        //         final step = state.steps[index];
        //         return Padding(
        //           padding: const EdgeInsets.only(bottom: 12),
        //           child: StepItemCard(step: step, index: index),
        //         );
        //       },
        //       childCount: state.steps.length,
        //     ),
        //   ),
        // ),
        const SliverToBoxAdapter(
            child: SizedBox(height: 96)), // spacing under FAB
      ],
    );
  }
}
