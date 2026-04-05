import 'package:hive_flutter/hive_flutter.dart';
import 'package:inventory_management_mobile_app/domain/entities/product.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class ProductModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int quatity;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final int minStock;

  ProductModel({
    required this.id,
    required this.name,
    required this.quatity,
    required this.category,
    required this.minStock,
  });

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id:product.id,
      name: product.name,
      quatity: product.quatity,
      category: product.category,
      minStock: product.minStock,
    );
  }

  Product toEntity() {
    return Product(
      id:id,
      name: name,
      quatity: quatity,
      category: category,
      minStock: minStock,
    );
  }
}
