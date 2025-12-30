import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:invoice_management_flutter_fe/utils/dio_interceptor.dart';

class ProductService {
  late final Dio api;

  ProductService() {
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

  Future<Response> getProducts() async {
    return await api.get('/products');
  }

  Future<Response> getProduct(String id) async {
    return await api.get('/products/$id');
  }

  Future<Response> createProduct(Map<String, dynamic> data) async {
    return await api.post('/products', data: data);
  }

  Future<Response> updateProduct(String id, Map<String, dynamic> data) async {
    return await api.put('/products/$id', data: data);
  }

  Future<Response> deleteProduct(String id) async {
    return await api.delete('/products/$id');
  }
}
