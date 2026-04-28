import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/domain/entities/product_status.dart';
import 'package:inventory_management_mobile_app/domain/repository/product_status_repository.dart';

class ProductStatusProvider extends ChangeNotifier {
  final ProductStatusRepository productStatusRepository;

  ProductStatusProvider(this.productStatusRepository);

  final List<ProductStatus> _productStatuses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductStatus> get productStatuses =>
      List.unmodifiable(_productStatuses);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProductStatuses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedStatuses = await productStatusRepository.getProductStatus();
      // Sort by timestamp descending (latest first)
      fetchedStatuses.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      _productStatuses
        ..clear()
        ..addAll(fetchedStatuses);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Error loading product statuses: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProductStatus(ProductStatus productStatus) async {
    try {
      await productStatusRepository.addProductStatus(productStatus);
      _productStatuses.insert(0, productStatus);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error adding product status: $e";
      notifyListeners();
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
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Error updating product status: $e";
      notifyListeners();
    }
  }

  Future<void> deleteProductStatus(int key) async {
    try {
      await productStatusRepository.deleteProductStatus(key);
      _productStatuses.removeAt(key);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error deleting product status: $e";
      notifyListeners();
    }
  }

  Future<void> clearAllProductStatuses() async {
    try {
      await productStatusRepository.clearAllProductStatus();
      _productStatuses.clear();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error clearing product statuses: $e";
      notifyListeners();
    }
  }

  Future<void> replaceAllProductStatuses(
    List<ProductStatus> productStatuses,
  ) async {
    try {
      await productStatusRepository.clearAllProductStatus();
      for (final status in productStatuses) {
        await productStatusRepository.addProductStatus(status);
      }
      // Keep latest-first ordering for UI.
      productStatuses.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      _productStatuses
        ..clear()
        ..addAll(productStatuses);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error replacing product statuses: $e";
      notifyListeners();
      rethrow;
    }
  }
}
