import 'package:invoice_management_flutter_fe/models/receipt_model.dart';
import 'package:invoice_management_flutter_fe/services/receipt_service.dart';

class ReceiptRepository {
  ReceiptService receiptService;

  ReceiptRepository(this.receiptService);

  Future<List<ReceiptModel>> getReceipts() async {
    final res = await receiptService.getReceipts();
    return (res.data as List).map((e) => ReceiptModel.fromJson(e)).toList();
  }

  Future<ReceiptModel> create(Map<String, dynamic> data) async {
    final res = await receiptService.createReceipt(data);
    return ReceiptModel.fromJson(res.data);
  }

  Future<ReceiptModel> update(String id, Map<String, dynamic> data) async {
    final res = await receiptService.updateReceipt(id, data);
    return ReceiptModel.fromJson(res.data);
  }

  Future<void> delete(String id) async {
    await receiptService.deleteReceipt(id);
  }
}
