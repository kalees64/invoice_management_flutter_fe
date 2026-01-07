import 'package:invoice_management_flutter_fe/models/invoice_model.dart';
import 'package:invoice_management_flutter_fe/models/user_model.dart';

class ReceiptModel {
  final String id;
  final String receiptNo;
  final InvoiceModel invoice;
  final UserModel customer;
  final double invoiceTotal;
  final double paidAmount;
  final double balanceAmount;
  final String paymentMethod;
  final String? transactionId; // CASH | UPI | CARD | BANK_TRANSFER | CHEQUE
  final String paymentStatus; // PAID | PARTIALLY_PAID
  final DateTime receiptDate;

  ReceiptModel({
    required this.id,
    required this.receiptNo,
    required this.invoice,
    required this.customer,
    required this.invoiceTotal,
    required this.paidAmount,
    required this.balanceAmount,
    required this.paymentMethod,
    required this.transactionId,
    required this.paymentStatus,
    required this.receiptDate,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    return ReceiptModel(
      id: json['id'],
      receiptNo: json['receiptNo'],
      invoice: InvoiceModel.fromJson(json['invoice']),
      customer: UserModel.fromJson(json['customer']),
      invoiceTotal: json['invoiceTotal'],
      paidAmount: json['paidAmount'],
      balanceAmount: json['balanceAmount'],
      paymentMethod: json['paymentMethod'],
      transactionId: json['transactionId'],
      paymentStatus: json['paymentStatus'],
      receiptDate: DateTime.parse(json['receiptDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiptNo': receiptNo,
      'invoice': invoice.toJson(),
      'customer': customer.toJson(),
      'invoiceTotal': invoiceTotal,
      'paidAmount': paidAmount,
      'balanceAmount': balanceAmount,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'paymentStatus': paymentStatus,
      'receiptDate': receiptDate.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ReceiptModel{id: $id, receiptNo: $receiptNo, invoice: $invoice, customer: $customer, invoiceTotal: $invoiceTotal, paidAmount: $paidAmount, balanceAmount: $balanceAmount, paymentMethod: $paymentMethod, transactionId: $transactionId, paymentStatus: $paymentStatus, receiptDate: $receiptDate}';
  }
}
