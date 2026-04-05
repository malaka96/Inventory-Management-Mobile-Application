import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/data/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> productList = [];
  bool isLoading = false;

  void addNewProduct(ProductModel product) {
    productList.add(product);
    notifyListeners();
  }
}
