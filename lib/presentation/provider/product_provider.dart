import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/domain/entities/product.dart';
import 'package:inventory_management_mobile_app/domain/repository/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository productRepository;

  ProductProvider(this.productRepository);

  final List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedProducts = await productRepository.getProducts();
      _products
        ..clear()
        ..addAll(fetchedProducts);
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
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Error adding product: $e");
    }
  }
  
}
