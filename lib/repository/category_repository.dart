// import 'package:dio/dio.dart';
// import '../services/dio_service.dart';
// import '../models/food_api_categories_data_model.dart';
//
// class CategoryRepository {
//   final DioService _dioService = DioService();
//   static List<Categories>? _cachedCategories; // Cache to avoid unnecessary API calls
//
//   Future<List<Categories>?> fetchCategories({bool forceRefresh = false}) async {
//     // Use cached data if available and not forcing refresh
//     if (_cachedCategories != null && !forceRefresh) {
//       return _cachedCategories;
//     }
//
//     try {
//       Response? response = await _dioService.getRequest("categories.php");
//
//       if (response != null && response.statusCode == 200) {
//         List<Categories>? categories =
//             FoodApiCategoriesDataModel.fromJson(response.data).categories;
//
//         if (categories != null && categories.isNotEmpty) {
//           _cachedCategories = categories; // Store in cache
//           return categories;
//         }
//       }
//       throw Exception("No categories found");
//     } catch (e) {
//       print("❌ Error fetching categories: $e");
//       throw Exception("Failed to load categories. Please try again.");
//     }
//   }
//
//   /// Clears cache when needed
//   void clearCache() {
//     _cachedCategories = null;
//   }
// }

import 'package:dio/dio.dart';
import '../services/dio_service.dart';
import '../models/food_api_categories_data_model.dart';

class CategoryRepository {
  final DioService _dioService = DioService();
  static List<Categories>? _cachedCategories; // ✅ Cache to avoid unnecessary API calls

  Future<List<Categories>> fetchCategories({bool forceRefresh = false}) async {
    // ✅ Use cached data and notify UI properly
    if (_cachedCategories != null && !forceRefresh) {
      return Future.value(_cachedCategories); // ✅ Returns immediately without flickering
    }

    try {
      Response? response = await _dioService.getRequest("categories.php");

      if (response != null && response.statusCode == 200) {
        List<Categories>? categories =
            FoodApiCategoriesDataModel.fromJson(response.data).categories;

        if (categories != null && categories.isNotEmpty) {
          _cachedCategories = categories; // ✅ Store in cache
          return categories;
        }
      }
      return []; // ✅ Instead of throwing an exception, return an empty list
    } catch (e) {
      print("❌ Error fetching categories: $e");
      return []; // ✅ Prevents flickering by returning an empty list instead of throwing an exception
    }
  }

  /// ✅ Clears cache properly
  void clearCache() {
    _cachedCategories = null;
  }
}
