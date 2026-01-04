import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:invoice_management_flutter_fe/utils/dio_interceptor.dart';

class QuotationService {
  late final Dio api;

  QuotationService() {
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

  Future<Response> getQuotations() async {
    return await api.get('/quotations');
  }

  Future<Response> createQuotation(Map<String, dynamic> data) async {
    return await api.post('/quotations', data: data);
  }
}
