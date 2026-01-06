class ProductModel {
  String id;
  String name;
  String category;
  String unitOfMeasurement;
  int openingStock;
  int minimumStockLevel;
  double costPrice;
  double sellingPrice;
  String status;
  int? quantity;

  ProductModel({
    required this.id,
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
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
    return 'ProductModel{id: $id, name: $name, category: $category, unitOfMeasurement: $unitOfMeasurement, openingStock: $openingStock, minimumStockLevel: $minimumStockLevel, costPrice: $costPrice, sellingPrice: $sellingPrice, status: $status}, quantity: $quantity';
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    String? unitOfMeasurement,
    int? openingStock,
    int? minimumStockLevel,
    double? costPrice,
    double? sellingPrice,
    String? status,
    int? quantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      unitOfMeasurement: unitOfMeasurement ?? this.unitOfMeasurement,
      openingStock: openingStock ?? this.openingStock,
      minimumStockLevel: minimumStockLevel ?? this.minimumStockLevel,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
    );
  }
}
