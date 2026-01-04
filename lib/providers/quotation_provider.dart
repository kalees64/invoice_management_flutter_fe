import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/models/quotation_model.dart';
import 'package:invoice_management_flutter_fe/repository/quotation_repository.dart';
import 'package:invoice_management_flutter_fe/services/quotation_service.dart';

class QuotationProvider extends ChangeNotifier {
  List<QuotationModel> _quotations = [];

  List<QuotationModel> get quotations => _quotations;

  void getQuotations() async {
    final res = await QuotationRepository(QuotationService()).getQuotations();
    _quotations = res;
    notifyListeners();
  }

  void addQuotation(QuotationModel quotation) async {
    await QuotationRepository(QuotationService()).create(quotation.toJson());
    getQuotations();
  }
}
