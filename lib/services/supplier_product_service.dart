import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:invoice_management_flutter_fe/utils/dio_interceptor.dart';

class SupplierProductService {
  late final Dio api;
  SupplierProductService() {
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

  Future<Response> getSupplierProducts() async {
    return await api.get('/supplier-products');
  }

  Future<Response> createSupplierProduct(Map<String, dynamic> data) async {
    return await api.post('/supplier-products', data: data);
  }

  Future<Response> updateSupplierProduct(
    String id,
    Map<String, dynamic> data,
  ) async {
    return await api.put('/supplier-products/$id', data: data);
  }

  Future<Response> deleteSupplierProduct(String id) async {
    return await api.delete('/supplier-products/$id');
  }
}
