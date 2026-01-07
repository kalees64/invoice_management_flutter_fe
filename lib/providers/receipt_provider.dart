import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/models/receipt_model.dart';
import 'package:invoice_management_flutter_fe/repository/receipt_repository.dart';
import 'package:invoice_management_flutter_fe/services/receipt_service.dart';

class ReceiptProvider extends ChangeNotifier {
  List<ReceiptModel> _receipts = [];

  List<ReceiptModel> get receipts => _receipts;

  void getReceipts() async {
    final res = await ReceiptRepository(ReceiptService()).getReceipts();
    _receipts = res;
    notifyListeners();
  }

  void addReceipt(ReceiptModel receipt) async {
    await ReceiptRepository(ReceiptService()).create(receipt.toJson());
    getReceipts();
  }

  void updateReceipt(ReceiptModel receipt) async {
    await ReceiptRepository(
      ReceiptService(),
    ).update(receipt.id, receipt.toJson());
    getReceipts();
  }

  void deleteReceipt(String id) async {
    await ReceiptRepository(ReceiptService()).delete(id);
    getReceipts();
  }
}
