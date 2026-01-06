import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/models/invoice_model.dart';
import 'package:invoice_management_flutter_fe/repository/invoice_repository.dart';
import 'package:invoice_management_flutter_fe/services/invoice_service.dart';

class InvoiceProvider extends ChangeNotifier {
  List<InvoiceModel> _invoices = [];

  List<InvoiceModel> get invoices => _invoices;

  void getInvoices() async {
    final res = await InvoiceRepository(InvoiceService()).getInvoices();
    _invoices = res;
    notifyListeners();
  }

  void addInvoice(InvoiceModel invoice) async {
    await InvoiceRepository(InvoiceService()).create(invoice.toJson());
    getInvoices();
  }

  void updateInvoice(InvoiceModel invoice) async {
    await InvoiceRepository(
      InvoiceService(),
    ).update(invoice.id, invoice.toJson());
    getInvoices();
  }

  void deleteInvoice(String id) async {
    await InvoiceRepository(InvoiceService()).delete(id);
    getInvoices();
  }
}
