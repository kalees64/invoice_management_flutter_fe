import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/models/supplier_product_model.dart';
import 'package:invoice_management_flutter_fe/repository/supplier_product_repository.dart';
import 'package:invoice_management_flutter_fe/services/supplier_product_service.dart';

class SupplierProductProvider extends ChangeNotifier {
  List<SupplierProductModel> _supplierProducts = [];

  List<SupplierProductModel> get supplierProducts => _supplierProducts;

  void getSupplierProducts() async {
    final res = await SupplierProductRepository(
      SupplierProductService(),
    ).getSupplierProducts();
    _supplierProducts = res;
    notifyListeners();
  }

  void addSupplierProduct(SupplierProductModel supplierProduct) async {
    await SupplierProductRepository(
      SupplierProductService(),
    ).create(supplierProduct.toJson());
    getSupplierProducts();
  }

  void updateSupplierProduct(SupplierProductModel supplierProduct) async {
    await SupplierProductRepository(
      SupplierProductService(),
    ).update(supplierProduct.id, supplierProduct.toJson());
    getSupplierProducts();
  }

  void deleteSupplierProduct(String id) async {
    await SupplierProductRepository(SupplierProductService()).delete(id);
    getSupplierProducts();
  }
}
