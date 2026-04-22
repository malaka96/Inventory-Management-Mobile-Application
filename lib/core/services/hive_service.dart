import 'package:hive_flutter/hive_flutter.dart';
import 'package:inventory_management_mobile_app/core/constants/hive_boxes.dart';
import 'package:inventory_management_mobile_app/data/models/product_model.dart';
import 'package:inventory_management_mobile_app/data/models/product_status_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProductModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ProductStatusModelAdapter());
    }
    await Hive.openBox<ProductModel>(HiveBoxes.product);
    await Hive.openBox<ProductStatusModel>(HiveBoxes.productStatus);
  }
}
