import 'package:inventory_management_mobile_app/data/models/product_status_model.dart';
import 'package:inventory_management_mobile_app/data/source/local/product_status_local_data_source.dart';
import 'package:inventory_management_mobile_app/domain/entities/product_status.dart';
import 'package:inventory_management_mobile_app/domain/repository/product_status_repository.dart';

class ProductStatusRepositoryImpl extends ProductStatusRepository {
  final ProductStatusLocalDataSource localDataSource;

  ProductStatusRepositoryImpl(this.localDataSource);

  @override
  Future<List<ProductStatus>> getProductStatus() async {
    return localDataSource.getAllProductStatus().then(
      (statusModels) => statusModels.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<void> addProductStatus(ProductStatus productStatus) async {
    return localDataSource.addProductStatus(
      ProductStatusModel.fromEntity(productStatus),
    );
  }

  @override
  Future<void> updateProductStatus(int key, ProductStatus productStatus) async {
    return localDataSource.updateProductStatus(
      key,
      ProductStatusModel.fromEntity(productStatus),
    );
  }

  @override
  Future<void> deleteProductStatus(int key) async {
    return localDataSource.deleteProductStatus(key);
  }

  @override
  Future<void> clearAllProductStatus() async {
    return localDataSource.clearAll();
  }
}
