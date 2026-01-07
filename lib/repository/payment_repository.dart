import 'package:invoice_management_flutter_fe/models/payment_model.dart';
import 'package:invoice_management_flutter_fe/services/payment_service.dart';

class PaymentRepository {
  PaymentService paymentService;

  PaymentRepository(this.paymentService);

  Future<List<PaymentModel>> getPayments() async {
    final res = await paymentService.getPayments();
    return (res.data as List).map((e) => PaymentModel.fromJson(e)).toList();
  }

  Future<PaymentModel> create(Map<String, dynamic> data) async {
    final res = await paymentService.createPayment(data);
    return PaymentModel.fromJson(res.data);
  }

  Future<PaymentModel> update(String id, Map<String, dynamic> data) async {
    final res = await paymentService.updatePayment(id, data);
    return PaymentModel.fromJson(res.data);
  }

  Future<void> delete(String id) async {
    await paymentService.deletePayment(id);
  }
}
