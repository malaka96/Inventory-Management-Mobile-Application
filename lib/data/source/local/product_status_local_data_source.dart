import 'package:hive_flutter/hive_flutter.dart';
import 'package:inventory_management_mobile_app/data/models/product_status_model.dart';

class ProductStatusLocalDataSource {
  Box<ProductStatusModel> get _productStatusBox =>
      Hive.box<ProductStatusModel>('product_status_box');

  Future<void> addProductStatus(ProductStatusModel productStatus) async {
    await _productStatusBox.add(productStatus);
  }

  Future<List<ProductStatusModel>> getAllProductStatus() async {
    return _productStatusBox.values.toList();
  }

  Future<void> updateProductStatus(
    int key,
    ProductStatusModel productStatus,
  ) async {
    await _productStatusBox.put(key, productStatus);
  }

  Future<void> deleteProductStatus(int key) async {
    await _productStatusBox.delete(key);
  }

  Future<void> clearAll() async {
    await _productStatusBox.clear();
  }
}
