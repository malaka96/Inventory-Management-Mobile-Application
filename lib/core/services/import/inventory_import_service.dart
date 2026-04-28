import 'dart:convert';

import 'package:inventory_management_mobile_app/domain/entities/product.dart';
import 'package:inventory_management_mobile_app/domain/entities/product_status.dart';

class InventoryImportData {
  final List<Product> products;
  final List<ProductStatus> productStatuses;

  const InventoryImportData({
    required this.products,
    required this.productStatuses,
  });
}

class InventoryImportService {
  const InventoryImportService();

  InventoryImportData parseExportedJson(String contents) {
    final dynamic decoded = jsonDecode(contents);
    if (decoded is! Map) {
      throw const FormatException('Invalid backup format');
    }

    final schemaVersion = decoded['schemaVersion'];
    if (schemaVersion != null && schemaVersion != 1) {
      throw FormatException('Unsupported schemaVersion: $schemaVersion');
    }

    final productsRaw = decoded['products'];
    final statusesRaw = decoded['productStatuses'];

    if (productsRaw is! List || statusesRaw is! List) {
      throw const FormatException('Backup missing required fields');
    }

    final products = productsRaw.map<Product>((p) {
      if (p is! Map) throw const FormatException('Invalid product entry');
      return Product(
        id: (p['id'] as num).toInt(),
        name: (p['name'] as String),
        quatity: (p['quatity'] as num).toInt(),
        category: (p['category'] as String),
        minStock: (p['minStock'] as num).toInt(),
      );
    }).toList();

    final statuses = statusesRaw.map<ProductStatus>((s) {
      if (s is! Map) throw const FormatException('Invalid product status entry');
      return ProductStatus(
        productName: (s['productName'] as String),
        status: (s['status'] as bool),
        timestamp: DateTime.parse(s['timestamp'] as String),
        value: (s['value'] as num).toInt(),
      );
    }).toList();

    return InventoryImportData(products: products, productStatuses: statuses);
  }
}

