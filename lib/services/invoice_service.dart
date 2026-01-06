import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:invoice_management_flutter_fe/utils/dio_interceptor.dart';

class InvoiceService {
  late final Dio api;

  InvoiceService() {
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

  Future<Response> getInvoices() async {
    return await api.get('/invoices');
  }

  Future<Response> createInvoice(Map<String, dynamic> data) async {
    return await api.post('/invoices', data: data);
  }

  Future<Response> updateInvoice(String id, Map<String, dynamic> data) async {
    return await api.put('/invoices/$id', data: data);
  }

  Future<Response> deleteInvoice(String id) async {
    return await api.delete('/invoices/$id');
  }
}
