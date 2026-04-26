import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/domain/entities/product_status.dart';
import 'package:inventory_management_mobile_app/domain/repository/product_status_repository.dart';

class ProductStatusProvider extends ChangeNotifier {
  final ProductStatusRepository productStatusRepository;

  ProductStatusProvider(this.productStatusRepository);

  final List<ProductStatus> _productStatuses = [];
  bool _isLoading = false;

  List<ProductStatus> get productStatuses =>
      List.unmodifiable(_productStatuses);
  bool get isLoading => _isLoading;

  Future<void> loadProductStatuses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedStatuses = await productStatusRepository.getProductStatus();
      _productStatuses
        ..clear()
        ..addAll(fetchedStatuses);
    } catch (e) {
      // Handle error, e.g., log or show a message
      print("Error loading product statuses: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProductStatus(ProductStatus productStatus) async {
    try {
      await productStatusRepository.addProductStatus(productStatus);
      _productStatuses.add(productStatus);
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Error adding product status: $e");
    }
  }

  Future<void> updateProductStatus(int key, ProductStatus productStatus) async {
    try {
      await productStatusRepository.updateProductStatus(key, productStatus);
      final index = _productStatuses.indexWhere(
        (p) => p.timestamp == productStatus.timestamp,
      );
      if (index != -1) {
        _productStatuses[index] = productStatus;
        notifyListeners();
      }
    } catch (e) {
      print("Error updating product status: $e");
    }
  }

  Future<void> deleteProductStatus(int key) async {
    try {
      await productStatusRepository.deleteProductStatus(key);
      _productStatuses.removeAt(key);
      notifyListeners();
    } catch (e) {
      print("Error deleting product status: $e");
    }
  }

  Future<void> clearAllProductStatuses() async {
    try {
      await productStatusRepository.clearAllProductStatus();
      _productStatuses.clear();
      notifyListeners();
    } catch (e) {
      print("Error clearing product statuses: $e");
    }
  }
}
