import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:invoice_management_flutter_fe/utils/dio_interceptor.dart';

class PaymentService {
  late final Dio api;
  PaymentService() {
    final baseUrl = dotenv.env['API_URL'];
    if (baseUrl == null) {
      throw Exception("API_URL not found in .env");
    }
    api = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    api.interceptors.add(DioAuthInterceptor());
  }
  Future<Response> getPayments() async {
    return await api.get('/payments');
  }

  Future<Response> createPayment(Map<String, dynamic> data) async {
    return await api.post('/payments', data: data);
  }

  Future<Response> updatePayment(String id, Map<String, dynamic> data) async {
    return await api.put('/payments/$id', data: data);
  }

  Future<Response> deletePayment(String id) async {
    return await api.delete('/payments/$id');
  }
}
