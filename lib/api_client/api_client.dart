import 'package:dio/dio.dart';
import 'package:mock_api/api_client/mock_interceptor.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://official-joke-api.appspot.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    )..interceptors.add(MockInterceptor());
  }

  Dio get dio => _dio;
}
