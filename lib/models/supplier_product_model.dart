import 'package:invoice_management_flutter_fe/models/supplier_model.dart';

class SupplierProductModel {
  final String id;
  final SupplierModel supplier;
  String name;
  String category;
  String unitOfMeasurement;
  int openingStock;
  int minimumStockLevel;
  double costPrice;
  double sellingPrice;
  String status;
  int? quantity;

  SupplierProductModel({
    required this.id,
    required this.supplier,
    required this.name,
    required this.category,
    required this.unitOfMeasurement,
    required this.openingStock,
    required this.minimumStockLevel,
    required this.costPrice,
    required this.sellingPrice,
    required this.status,
    this.quantity = 1,
  });

  factory SupplierProductModel.fromJson(Map<String, dynamic> json) {
    return SupplierProductModel(
      id: json['id'],
      supplier: SupplierModel.fromJson(json['supplier']),
      name: json['name'],
      category: json['category'],
      unitOfMeasurement: json['unitOfMeasurement'],
      openingStock: json['openingStock'],
      minimumStockLevel: json['minimumStockLevel'],
      costPrice: json['costPrice'],
      sellingPrice: json['sellingPrice'],
      status: json['status'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplier': supplier.toJson(),
      'name': name,
      'category': category,
      'unitOfMeasurement': unitOfMeasurement,
      'openingStock': openingStock,
      'minimumStockLevel': minimumStockLevel,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
      'status': status,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return 'SupplierProductModel{id: $id, supplier: $supplier, name: $name, category: $category, unitOfMeasurement: $unitOfMeasurement, openingStock: $openingStock, minimumStockLevel: $minimumStockLevel, costPrice: $costPrice, sellingPrice: $sellingPrice, status: $status}, quantity: $quantity';
  }
}
