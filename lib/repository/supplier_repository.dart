import 'package:invoice_management_flutter_fe/models/supplier_model.dart';
import 'package:invoice_management_flutter_fe/services/supplier_service.dart';

class SupplierRepository {
  SupplierService supplierService;

  SupplierRepository(this.supplierService);

  Future<List<SupplierModel>> getSuppliers() async {
    final res = await supplierService.getSuppliers();
    return (res.data as List).map((e) => SupplierModel.fromJson(e)).toList();
  }

  Future<SupplierModel> create(Map<String, dynamic> data) async {
    final res = await supplierService.createSupplier(data);
    return SupplierModel.fromJson(res.data);
  }

  Future<SupplierModel> update(String id, Map<String, dynamic> data) async {
    final res = await supplierService.updateSupplier(id, data);
    return SupplierModel.fromJson(res.data);
  }

  Future<void> delete(String id) async {
    await supplierService.deleteSupplier(id);
  }
}
