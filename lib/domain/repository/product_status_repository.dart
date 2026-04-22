import 'package:inventory_management_mobile_app/domain/entities/product_status.dart';

abstract class ProductStatusRepository {
  Future<List<ProductStatus>> getProductStatus();
  Future<void> addProductStatus(ProductStatus productStatus);
  Future<void> updateProductStatus(int key, ProductStatus productStatus);
  Future<void> deleteProductStatus(int key);
  Future<void> clearAllProductStatus();
}
