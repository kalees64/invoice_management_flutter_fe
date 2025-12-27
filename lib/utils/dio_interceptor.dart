import 'dart:developer';
import 'package:dio/dio.dart';

class DioAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = "VK64";

    options.headers['Authorization'] = 'Bearer $token';

    options.headers['Content-Type'] = 'application/json';

    log("➡️ REQUEST [${options.method}] ${options.uri}");
    log("Headers: ${options.headers}");
    log("Body: ${options.data}");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("✅ RESPONSE [${response.statusCode}] ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("❌ ERROR [${err.response?.statusCode}] ${err.message}");

    if (err.response?.statusCode == 401) {
      // You can trigger logout or redirect here
      log("Unauthorized");
    }

    super.onError(err, handler);
  }
}
