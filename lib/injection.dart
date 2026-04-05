import 'package:inventory_management_mobile_app/data/repository/product_repository_impl.dart';
import 'package:inventory_management_mobile_app/data/source/local/product_local_data_source.dart';

late final ProductLocalDataSource productLocalDataSource;
late final ProductRepositoryImpl productRepositoryImpl;

Future<void> initInjection() async {
  productLocalDataSource = ProductLocalDataSource();
  productRepositoryImpl = ProductRepositoryImpl(productLocalDataSource);
}
