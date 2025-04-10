import 'package:home_staff/infra/house/entity/building_entity.dart';
import 'package:home_staff/infra/house/entity/house.dart';
import 'package:home_staff/infra/order/entity/order_entity.dart';
import 'package:home_staff/infra/user/entity/user_entity.dart';

class OrderDetailState {
  final bool isLoading;
  final String? errorMessage;
  final Order? order;
  final User? user;
  final House? house;
  final Building? building; // ✅ thêm

  const OrderDetailState({
    this.isLoading = false,
    this.errorMessage,
    this.order,
    this.user,
    this.house,
    this.building,
  });

  OrderDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    Order? order,
    User? user,
    House? house,
    Building? building, // ✅ thêm
  }) {
    return OrderDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      order: order ?? this.order,
      user: user ?? this.user,
      house: house ?? this.house,
      building: building ?? this.building,
    );
  }
}
