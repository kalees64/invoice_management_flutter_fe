import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/models/product_model.dart';
import 'package:invoice_management_flutter_fe/services/product_service.dart';
import 'package:invoice_management_flutter_fe/store/products/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  void getProducts() async {
    final res = await ProductRepository(ProductService()).getProducts();
    _products = res;
    notifyListeners();
  }

  void getProduct(String id) async {
    final res = await ProductRepository(ProductService()).get(id);
    _products = [res];
    notifyListeners();
  }

  void addProduct(ProductModel product) async {
    await ProductRepository(ProductService()).create(product.toJson());
    getProducts();
  }

  void updateProduct(ProductModel product) async {
    await ProductRepository(
      ProductService(),
    ).update(product.id, product.toJson());
    getProducts();
  }

  void deleteProduct(String id) async {
    await ProductRepository(ProductService()).delete(id);
    getProducts();
  }
}
