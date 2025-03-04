// import 'package:dio/dio.dart';
//
// class DioService {
//   final Dio _dio;
//
//   DioService()
//       : _dio = Dio(
//     BaseOptions(
//       baseUrl: 'https://www.themealdb.com/api/json/v1/1/',
//       connectTimeout: const Duration(seconds: 5),
//       receiveTimeout: const Duration(seconds: 3),
//     ),
//   ) {
//     _dio.interceptors.add(LogInterceptor(responseBody: true));
//   }
//
//   Future<Response?> getRequest(String endpoint) async {
//     try {
//       Response response = await _dio.get(endpoint);
//       return response;
//     } catch (e) {
//       print("Dio error: $e");
//       return null;
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';

class DioService {
  static final DioService _instance = DioService._internal();
  late final Dio _dio;
  late final DioCacheInterceptor _cacheInterceptor;

  factory DioService() => _instance;

  DioService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.themealdb.com/api/json/v1/1/',
        connectTimeout: const Duration(seconds: 10), // Increased timeout
        receiveTimeout: const Duration(seconds: 7),
      ),
    );

    // Initialize cache
    _cacheInterceptor = DioCacheInterceptor(
      options: CacheOptions(
        store: HiveCacheStore("cache"), // Store cache in Hive
        policy: CachePolicy.request, // Use cache when available
        maxStale: const Duration(days: 7), // Cache expires in 7 days
        priority: CachePriority.high,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_cacheInterceptor);
    _dio.interceptors.add(LogInterceptor(responseBody: true)); // Log requests
  }

  Future<Response?> getRequest(String endpoint, {bool forceRefresh = false}) async {
    try {
      Response response = await _dio.get(
        endpoint,
        options: forceRefresh
            ? Options(headers: {"Cache-Control": "no-cache"}) // Force fresh data
            : null,
      );
      return response;
    } on DioException catch (e) {
      print("❌ DioException: ${e.message}");
      if (e.response != null) {
        print("🔴 Response Data: ${e.response?.data}");
      }
      return null;
    } catch (e) {
      print("❌ General Error: $e");
      return null;
    }
  }

  void dispose() {
    _dio.close();
  }
}
