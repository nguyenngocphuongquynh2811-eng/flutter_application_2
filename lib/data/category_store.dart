import 'package:flutter/material.dart';

import '../models/category.dart';
import 'mock_data.dart';

/// Quản lý danh mục sản phẩm (iPhone, Watch, iPad, Mac, AirPods...).
class CategoryStore extends ChangeNotifier {
  final List<Category> _categories = List.of(MockData.categories);

  List<Category> get categories => List.unmodifiable(_categories);

  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void updateCategory(String id, Category category) {
    final index = _categories.indexWhere((e) => e.id == id);
    if (index == -1) return;
    _categories[index] = category;
    notifyListeners();
  }

  void deleteCategory(String id) {
    _categories.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}