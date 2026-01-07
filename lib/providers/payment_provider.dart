import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/models/payment_model.dart';
import 'package:invoice_management_flutter_fe/repository/payment_repository.dart';
import 'package:invoice_management_flutter_fe/services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  List<PaymentModel> _payments = [];

  List<PaymentModel> get payments => _payments;

  void getPayments() async {
    final res = await PaymentRepository(PaymentService()).getPayments();
    _payments = res;
    notifyListeners();
  }

  void addPayment(PaymentModel payment) async {
    await PaymentRepository(PaymentService()).create(payment.toJson());
    getPayments();
  }

  void updatePayment(PaymentModel payment) async {
    await PaymentRepository(
      PaymentService(),
    ).update(payment.id, payment.toJson());
    getPayments();
  }

  void deletePayment(String id) async {
    await PaymentRepository(PaymentService()).delete(id);
    getPayments();
  }
}
