import 'package:invoice_management_flutter_fe/models/supplier_product_model.dart';
import 'package:invoice_management_flutter_fe/services/supplier_product_service.dart';

class SupplierProductRepository {
  SupplierProductService supplierProductService;

  SupplierProductRepository(this.supplierProductService);

  Future<List<SupplierProductModel>> getSupplierProducts() async {
    final res = await supplierProductService.getSupplierProducts();
    return (res.data as List)
        .map((e) => SupplierProductModel.fromJson(e))
        .toList();
  }

  Future<SupplierProductModel> create(Map<String, dynamic> data) async {
    final res = await supplierProductService.createSupplierProduct(data);
    return SupplierProductModel.fromJson(res.data);
  }

  Future<SupplierProductModel> update(
    String id,
    Map<String, dynamic> data,
  ) async {
    final res = await supplierProductService.updateSupplierProduct(id, data);
    return SupplierProductModel.fromJson(res.data);
  }

  Future<void> delete(String id) async {
    await supplierProductService.deleteSupplierProduct(id);
  }
}
