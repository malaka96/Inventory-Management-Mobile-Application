import 'package:hive_flutter/hive_flutter.dart';
import 'package:inventory_management_mobile_app/data/models/product_model.dart';


class ProductLocalDataSource {
  Box<ProductModel> get _productBox => Hive.box<ProductModel>('products_box');

  Future<void> addProduct(ProductModel product) async {
    await _productBox.put(product.id, product);
  }

  Future<List<ProductModel>> getAllProducts() async {
    return _productBox.values.toList();
  }

  Future<void> updateProduct(ProductModel product) async {
    await _productBox.put(product.id, product);
  }

  Future<void> deleteProduct(int id) async {
    await _productBox.delete(id);
  }

  Future<void> delete(int id) async {
    await _productBox.delete(id);
  }

  Future<void> clearAll() async {
    await _productBox.clear();
  }
}
