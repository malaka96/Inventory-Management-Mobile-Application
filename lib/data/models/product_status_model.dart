import 'package:hive/hive.dart';

part 'product_status_model.g.dart';

@HiveType(typeId: 2)
class ProductStatusModel extends HiveObject {
  @HiveField(0)
  final String productName;

  @HiveField(1)
  final bool status; // true for in stock, false for out of stock

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final int value;

  ProductStatusModel({
    required this.productName,
    required this.status,
    required this.timestamp,
    required this.value,
  });
}

