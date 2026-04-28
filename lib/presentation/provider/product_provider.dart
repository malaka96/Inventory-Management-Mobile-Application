import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/domain/entities/product.dart';
import 'package:inventory_management_mobile_app/domain/repository/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository productRepository;

  ProductProvider(this.productRepository);

  final List<Product> _products = [];
  final List<Product> _lowStockProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => List.unmodifiable(_products);
  List<Product> get lowStockProducts => List.unmodifiable(_lowStockProducts);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get outOfStockCount => _products.where((p) => p.quatity <= 0).length;

  bool _isLowStock(Product product) => product.quatity <= product.minStock;

  void _rebuildLowStockProducts() {
    _lowStockProducts
      ..clear()
      ..addAll(_products.where(_isLowStock));
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedProducts = await productRepository.getProducts();
      _products
        ..clear()
        ..addAll(fetchedProducts);
      _rebuildLowStockProducts();
    } catch (e) {
      // Handle error, e.g., log or show a message
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await productRepository.addProduct(product);
      _products.add(product);
      _rebuildLowStockProducts();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error adding product: $e";
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await productRepository.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        _rebuildLowStockProducts();
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Error updating product: $e";
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int productId) async {
    try {
      await productRepository.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
      _lowStockProducts.removeWhere((p) => p.id == productId);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error deleting product: $e";
      notifyListeners();
    }
  }

  Future<void> clearAllProducts() async {
    try {
      await productRepository.clearAllProducts();
      _products.clear();
      _lowStockProducts.clear();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error clearing all products: $e";
      notifyListeners();
    }
  }

  Future<void> replaceAllProducts(List<Product> products) async {
    try {
      await productRepository.clearAllProducts();
      for (final product in products) {
        await productRepository.addProduct(product);
      }
      _products
        ..clear()
        ..addAll(products);
      _rebuildLowStockProducts();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error replacing products: $e";
      notifyListeners();
      rethrow;
    }
  }
}
