import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/models/supplier_model.dart';
import 'package:invoice_management_flutter_fe/repository/supplier_repository.dart';
import 'package:invoice_management_flutter_fe/services/supplier_service.dart';

class SupplierProvider extends ChangeNotifier {
  List<SupplierModel> _suppliers = [];

  List<SupplierModel> get suppliers => _suppliers;

  void getSuppliers() async {
    final res = await SupplierRepository(SupplierService()).getSuppliers();
    _suppliers = res;
    notifyListeners();
  }

  void addSupplier(SupplierModel supplier) async {
    await SupplierRepository(SupplierService()).create(supplier.toJson());
    getSuppliers();
  }

  void updateSupplier(SupplierModel supplier) async {
    await SupplierRepository(
      SupplierService(),
    ).update(supplier.id, supplier.toJson());
    getSuppliers();
  }

  void deleteSupplier(String id) async {
    await SupplierRepository(SupplierService()).delete(id);
    getSuppliers();
  }
}
