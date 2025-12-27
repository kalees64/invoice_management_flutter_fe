import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:invoice_management_flutter_fe/utils/dio_interceptor.dart';

class UserService {
  late final Dio api;

  UserService() {
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

  Future<Response> getUsers() async {
    return await api.get('/users');
  }

  Future<Response> getUser(String id) async {
    return await api.get('/users/$id');
  }

  Future<Response> createUser(Map<String, dynamic> data) async {
    return await api.post('/users', data: data);
  }

  Future<Response> updateUser(String id, Map<String, dynamic> data) async {
    return await api.put('/users/$id', data: data);
  }

  Future<Response> deleteUser(String id) async {
    return await api.delete('/users/$id');
  }
}
