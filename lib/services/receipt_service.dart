import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:invoice_management_flutter_fe/utils/dio_interceptor.dart';

class ReceiptService {
  late final Dio api;

  ReceiptService() {
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

  Future<Response> getReceipts() async {
    return await api.get('/receipts');
  }

  Future<Response> createReceipt(Map<String, dynamic> data) async {
    return await api.post('/receipts', data: data);
  }

  Future<Response> updateReceipt(String id, Map<String, dynamic> data) async {
    return await api.put('/receipts/$id', data: data);
  }

  Future<Response> deleteReceipt(String id) async {
    return await api.delete('/receipts/$id');
  }
}
