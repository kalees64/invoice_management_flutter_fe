import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:invoice_management_flutter_fe/utils/dio_interceptor.dart';

class SupplierService {
  late final Dio api;

  SupplierService() {
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

  Future<Response> getSuppliers() async {
    return await api.get('/suppliers');
  }

  Future<Response> createSupplier(Map<String, dynamic> data) async {
    return await api.post('/suppliers', data: data);
  }

  Future<Response> updateSupplier(String id, Map<String, dynamic> data) async {
    return await api.put('/suppliers/$id', data: data);
  }

  Future<Response> deleteSupplier(String id) async {
    return await api.delete('/suppliers/$id');
  }
}
