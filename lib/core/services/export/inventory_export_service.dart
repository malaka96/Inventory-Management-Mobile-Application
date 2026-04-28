import 'dart:convert';

import 'package:inventory_management_mobile_app/domain/entities/product.dart';
import 'package:inventory_management_mobile_app/domain/entities/product_status.dart';

class InventoryExportService {
  const InventoryExportService();

  String buildExportJson({
    required List<Product> products,
    required List<ProductStatus> productStatuses,
    required DateTime exportedAt,
  }) {
    final payload = <String, Object?>{
      'schemaVersion': 1,
      'exportedAt': exportedAt.toUtc().toIso8601String(),
      'products': products
          .map(
            (p) => <String, Object?>{
              'id': p.id,
              'name': p.name,
              'quatity': p.quatity,
              'category': p.category,
              'minStock': p.minStock,
            },
          )
          .toList(),
      'productStatuses': productStatuses
          .map(
            (s) => <String, Object?>{
              'productName': s.productName,
              'status': s.status,
              'timestamp': s.timestamp.toUtc().toIso8601String(),
              'value': s.value,
            },
          )
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }
}

