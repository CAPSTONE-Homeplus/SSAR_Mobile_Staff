import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_staff/features/order_detail/controllers/order_detail_state.dart';
import 'package:home_staff/infra/house/entity/building_entity.dart';
import 'package:home_staff/infra/house/entity/house.dart';
import 'package:home_staff/infra/house/service/house_provider.dart';
import 'package:home_staff/infra/house/service/house_repository.dart';
import 'package:home_staff/infra/order/service/order_repository.dart';
import 'package:home_staff/infra/order/service/provider/order_repository_provider.dart';
import 'package:home_staff/infra/user/entity/user_entity.dart';
import 'package:home_staff/infra/user/service/user_provider.dart';
import 'package:home_staff/infra/user/service/user_repository.dart';
import 'package:logger/logger.dart';

final logger = Logger();

final orderDetailControllerProvider = StateNotifierProvider.family<
    OrderDetailController, OrderDetailState, String>((ref, orderId) {
  final orderRepo = ref.read(orderRepositoryProvider);
  final userRepo = ref.read(userRepositoryProvider);
  final houseRepo = ref.read(houseRepositoryProvider);

  return OrderDetailController(
    orderId: orderId,
    orderRepository: orderRepo,
    userRepository: userRepo,
    houseRepository: houseRepo,
  );
});

class OrderDetailController extends StateNotifier<OrderDetailState> {
  final String orderId;
  final OrderRepository orderRepository;
  final UserRepository userRepository;
  final HouseRepository houseRepository;

  OrderDetailController({
    required this.orderId,
    required this.orderRepository,
    required this.userRepository,
    required this.houseRepository,
  }) : super(const OrderDetailState(isLoading: true)) {
    loadOrderDetail();
  }

  /// 🚀 Tải thông tin chi tiết đơn hàng
  Future<void> loadOrderDetail() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final order = await orderRepository.getOrderById(orderId);
      User? user;
      House? house;
      Building? building;

      if (order.userId?.isNotEmpty == true) {
        user = await userRepository.getUserById(order.userId!);
      }

      if (order.address.isNotEmpty) {
        house = await houseRepository.getHouseById(order.address);

        // 👇 Tải toà nhà từ house.buildingId
        if (house.buildingId.isNotEmpty) {
          building = await houseRepository.getBuildingById(house.buildingId);
        }
      }

      state = state.copyWith(
        order: order,
        user: user,
        house: house,
        building: building, // ✅ gán vào state
        isLoading: false,
      );
    } catch (e, s) {
      logger.e('❌ Lỗi khi load order detail', error: e, stackTrace: s);
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể tải chi tiết đơn hàng',
      );
    }
  }

  /// 🏠 Gọi lại thủ công nếu muốn refetch riêng House
  Future<House?> getHouseById() async {
    try {
      final houseId = state.order?.address;
      if (houseId == null || houseId.isEmpty) return null;

      final house = await houseRepository.getHouseById(houseId);
      state = state.copyWith(house: house);
      return house;
    } catch (e, s) {
      logger.e('❌ Lỗi khi tải nhà', error: e, stackTrace: s);
      return null;
    }
  }

  /// ✅ Check-in đơn hàng
  Future<bool> checkInOrder() async {
    try {
      final success = await orderRepository.orderCheckIn(orderId);
      if (success) await loadOrderDetail();
      return success;
    } catch (e, s) {
      logger.e('❌ Lỗi check-in đơn hàng', error: e, stackTrace: s);
      return false;
    }
  }

  /// 🧹 Check-out đơn hàng
  Future<bool> checkOutOrder() async {
    try {
      final success = await orderRepository.orderCheckOut(orderId);
      if (success) await loadOrderDetail();
      return success;
    } catch (e, s) {
      logger.e('❌ Lỗi check-out đơn hàng', error: e, stackTrace: s);
      return false;
    }
  }
}
