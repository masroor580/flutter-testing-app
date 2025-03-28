import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';

class DioService {
  late Dio _dio;
  bool _isCacheInitialized = false; // Track cache initialization status

  DioService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.themealdb.com/api/json/v1/1/',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );

    _initializeCache();
  }

  Future<void> _initializeCache() async {
    final dir = await getApplicationDocumentsDirectory(); // Get valid directory
    final store = HiveCacheStore(dir.path); // Use this directory for Hive cache

    final cacheOptions = CacheOptions(
      store: store,
      policy: CachePolicy.request,
      maxStale: const Duration(days: 7), // Cache expiration time
    );

    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    _isCacheInitialized = true; // Mark cache as initialized
  }

  Future<Response?> getRequest(String endpoint) async {
    // Ensure cache is initialized before making a request
    while (!_isCacheInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    try {
      Response response = await _dio.get(endpoint);
      return response;
    } catch (e) {
      print("Dio error: $e");
      return null;
    }
  }
}
