import 'package:invoice_management_flutter_fe/models/user_model.dart';

class InvoiceModel {
  final String id;
  final String invoiceNo;
  final String quotationId;
  final String quotationNo;
  int installmentNo;
  int totalInstallments;
  double installmentAmount;
  final UserModel customer;
  double totalQuotationAmount;
  double paidAmount;
  double balanceAmount;
  String status; // SENT, PAID, OVERDUE, DRAFT
  DateTime invoiceDate;
  DateTime dueDate;
  DateTime? paidDate;

  InvoiceModel({
    required this.id,
    required this.invoiceNo,
    required this.quotationId,
    required this.quotationNo,
    required this.installmentNo,
    required this.totalInstallments,
    required this.installmentAmount,
    required this.customer,
    required this.totalQuotationAmount,
    required this.paidAmount,
    required this.balanceAmount,
    required this.status,
    required this.invoiceDate,
    required this.dueDate,
    this.paidDate,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'],
      invoiceNo: json['invoiceNo'],
      quotationId: json['quotationId'],
      quotationNo: json['quotationNo'],
      installmentNo: json['installmentNo'],
      totalInstallments: json['totalInstallments'],
      installmentAmount: json['installmentAmount'],
      customer: UserModel.fromJson(json['customer']),
      totalQuotationAmount: json['totalQuotationAmount'],
      paidAmount: json['paidAmount'],
      balanceAmount: json['balanceAmount'],
      status: json['status'],
      invoiceDate: DateTime.parse(json['invoiceDate']),
      dueDate: DateTime.parse(json['dueDate']),
      paidDate: json['paidDate'] != null
          ? DateTime.parse(json['paidDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNo': invoiceNo,
      'quotationId': quotationId,
      'quotationNo': quotationNo,
      'installmentNo': installmentNo,
      'totalInstallments': totalInstallments,
      'installmentAmount': installmentAmount,
      'customer': customer.toJson(),
      'totalQuotationAmount': totalQuotationAmount,
      'paidAmount': paidAmount,
      'balanceAmount': balanceAmount,
      'status': status,
      'invoiceDate': invoiceDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'InvoiceModel{id: $id, invoiceNo: $invoiceNo, quotationId: $quotationId, quotationNo: $quotationNo, installmentNo: $installmentNo, totalInstallments: $totalInstallments, installmentAmount: $installmentAmount, customer: $customer, totalQuotationAmount: $totalQuotationAmount, paidAmount: $paidAmount, balanceAmount: $balanceAmount, status: $status, invoiceDate: $invoiceDate, dueDate: $dueDate, paidDate: $paidDate}';
  }
}
