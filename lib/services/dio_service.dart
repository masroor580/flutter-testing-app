import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';

class DioService {
  late Dio _dio;

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
      policy: CachePolicy.forceCache,
      maxStale: const Duration(days: 7), // Cache expiration time
    );

    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
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
