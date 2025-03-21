import 'package:home_staff/infra/purchases/entity/product.dart';
import 'package:home_staff/infra/purchases/entity/purchase_entity.dart';
import 'package:home_staff/infra/purchases/mock_purchase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final purchaseServiceProvider = Provider<PurchasesService>((ref) {
  return MockPurchaseService();
});

abstract interface class PurchasesService {
  Future<PurchaseEntity> init();
  Future<List<ProductEntity>> getProducts();
  Future<PurchaseEntity> purchaseProduct(ProductEntity product);
  Future<PurchaseEntity> restorePurchases();
}
