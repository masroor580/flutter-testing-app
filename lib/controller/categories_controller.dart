// import 'package:flutter/material.dart';
//
// import 'package:new_app/models/food_api_categories_data_model.dart';
// import '../repository/category_repository.dart';
//
// class CategoryController with ChangeNotifier {
//   final CategoryRepository _repository = CategoryRepository();
//   List<Categories>? _categories;
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   List<Categories>? get categories => _categories;
//
//   bool get isLoading => _isLoading;
//
//   String? get errorMessage => _errorMessage;
//
//   Future<void> fetchCategories() async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       _categories = await _repository.fetchCategories();
//     } catch (e) {
//       _errorMessage = "Failed to load categories";
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import '../models/food_api_categories_data_model.dart';
import '../repository/category_repository.dart';

class CategoryController with ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();

  List<Categories>? _categories;
  bool _isLoading = false;
  String? _errorMessage;

  static List<Categories>? _cachedCategories; // Cache data to prevent unnecessary API calls.

  List<Categories>? get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCategories({bool forceRefresh = false}) async {
    // Use cached data if available and not forcing refresh
    if (_cachedCategories != null && !forceRefresh) {
      _categories = _cachedCategories;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<Categories>? fetchedCategories = await _repository.fetchCategories();
      if (fetchedCategories!.isNotEmpty) {
        _categories = fetchedCategories;
        _cachedCategories = fetchedCategories; // Store in cache
      } else {
        _errorMessage = "No categories found.";
      }
    } catch (e) {
      _errorMessage = "Failed to load categories: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Clears cached data (useful if user refreshes manually)
  void clearCache() {
    _cachedCategories = null;
  }
}
