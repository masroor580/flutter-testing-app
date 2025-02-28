import 'package:dio/dio.dart';

class DioService {
  final Dio _dio;

  DioService()
      : _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.themealdb.com/api/json/v1/1/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  ) {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Response?> getRequest(String endpoint) async {
    try {
      Response response = await _dio.get(endpoint);
      return response;
    } catch (e) {
      print("Dio error: $e");
      return null;
    }
  }
}
