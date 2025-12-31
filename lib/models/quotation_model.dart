import 'package:invoice_management_flutter_fe/models/product_model.dart';
import 'package:invoice_management_flutter_fe/models/user_model.dart';

class QuotationModel {
  final String? id;
  final String quotationNo;
  final int revisionNo;
  final UserModel customer;
  final List<ProductModel> products;
  final double total;
  final String status; // DRAFT, SENT, ACCEPTED, REJECTED
  final DateTime date;

  QuotationModel({
    this.id,
    required this.quotationNo,
    required this.revisionNo,
    required this.customer,
    required this.products,
    required this.total,
    required this.status,
    required this.date,
  });

  factory QuotationModel.fromJson(Map<String, dynamic> json) {
    return QuotationModel(
      id: json['id'],
      quotationNo: json['quotationNo'],
      revisionNo: json['revisionNo'],
      customer: UserModel.fromJson(json['customer']),
      products: (json['products'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList(),
      total: json['total'],
      status: json['status'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quotationNo': quotationNo,
      'revisionNo': revisionNo,
      'customer': customer.toJson(),
      'products': products.map((e) => e.toJson()).toList(),
      'total': total,
      'status': status,
      'date': date.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'QuotationModel{id: $id, quotationNo : $quotationNo, revisionNo: $revisionNo, customer: $customer, products: $products, total: $total, status: $status, date: $date}';
  }
}
