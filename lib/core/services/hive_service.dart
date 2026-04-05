import 'package:hive_flutter/hive_flutter.dart';
import 'package:inventory_management_mobile_app/core/constants/hive_boxes.dart';
import 'package:inventory_management_mobile_app/data/models/product_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProductModelAdapter());
    }
    await Hive.openBox<ProductModel>(HiveBoxes.product);
  }
}
