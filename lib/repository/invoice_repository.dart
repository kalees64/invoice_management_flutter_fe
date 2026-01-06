import 'package:invoice_management_flutter_fe/models/invoice_model.dart';
import 'package:invoice_management_flutter_fe/services/invoice_service.dart';

class InvoiceRepository {
  InvoiceService invoiceService;

  InvoiceRepository(this.invoiceService);

  Future<List<InvoiceModel>> getInvoices() async {
    final res = await invoiceService.getInvoices();
    return (res.data as List).map((e) => InvoiceModel.fromJson(e)).toList();
  }

  Future<InvoiceModel> create(Map<String, dynamic> data) async {
    final res = await invoiceService.createInvoice(data);
    return InvoiceModel.fromJson(res.data);
  }

  Future<InvoiceModel> update(String id, Map<String, dynamic> data) async {
    final res = await invoiceService.updateInvoice(id, data);
    return InvoiceModel.fromJson(res.data);
  }

  Future<void> delete(String id) async {
    await invoiceService.deleteInvoice(id);
  }
}
