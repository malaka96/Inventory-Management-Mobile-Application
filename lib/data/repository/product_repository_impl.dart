import 'package:inventory_management_mobile_app/data/models/product_model.dart';
import 'package:inventory_management_mobile_app/data/source/local/product_local_data_source.dart';
import 'package:inventory_management_mobile_app/domain/entities/product.dart';
import 'package:inventory_management_mobile_app/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl(this.localDataSource);

  @override
  Future<List<Product>> getProducts() async {
    return localDataSource.getAllProducts().then((productModels) =>
        productModels.map((model) => model.toEntity()).toList());
  }

  @override
  Future<void> addProduct(Product product) async {
    return localDataSource.addProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> updateProduct(Product product) async {
    return localDataSource.updateProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> deleteProduct(int id) async {
    return localDataSource.delete(id);
  }

}