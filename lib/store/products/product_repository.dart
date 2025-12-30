import 'package:invoice_management_flutter_fe/models/product_model.dart';
import 'package:invoice_management_flutter_fe/services/product_service.dart';

class ProductRepository {
  ProductService productService;

  ProductRepository(this.productService);

  Future<List<ProductModel>> getProducts() async {
    final res = await productService.getProducts();
    return (res.data as List).map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<ProductModel> get(String id) async {
    final res = await productService.getProduct(id);
    return ProductModel.fromJson(res.data);
  }

  Future<ProductModel> create(Map<String, dynamic> data) async {
    final res = await productService.createProduct(data);
    return ProductModel.fromJson(res.data);
  }

  Future<ProductModel> update(String id, Map<String, dynamic> data) async {
    final res = await productService.updateProduct(id, data);
    return ProductModel.fromJson(res.data);
  }

  Future<void> delete(String id) async {
    await productService.deleteProduct(id);
  }
}
