import '../../../../data/product_data.dart';
import 'endpoints.dart';

import '../model/product_model.dart';
import '../../../../core/data_source/dio_helper.dart';

class ProductRepository {
  final DioService dioService;
  ProductRepository(this.dioService);

  Future<List<ProductModel>> getProducts() async {
    return ProductDataSource.products;
  }
}
