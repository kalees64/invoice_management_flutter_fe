import 'package:invoice_management_flutter_fe/models/quotation_model.dart';
import 'package:invoice_management_flutter_fe/services/quotation_service.dart';

class QuotationRepository {
  QuotationService quotationService;

  QuotationRepository(this.quotationService);

  Future<List<QuotationModel>> getQuotations() async {
    final res = await quotationService.getQuotations();
    return (res.data as List).map((e) => QuotationModel.fromJson(e)).toList();
  }

  Future<QuotationModel> create(Map<String, dynamic> data) async {
    final res = await quotationService.createQuotation(data);
    return QuotationModel.fromJson(res.data);
  }

  Future<QuotationModel> updateQuotation(
    String id,
    Map<String, dynamic> data,
  ) async {
    final res = await quotationService.updateQuotation(id, data);
    return QuotationModel.fromJson(res.data);
  }

  Future<void> deleteQuotation(String id) async {
    await quotationService.deleteQuotation(id);
  }
}
