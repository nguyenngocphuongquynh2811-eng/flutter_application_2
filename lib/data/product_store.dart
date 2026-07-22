//Phần lưu dl tạm thời của admin khi chỉnh sửa
import 'package:flutter/material.dart';

import '../models/product.dart';
import 'mock_data.dart';

class ProductStore extends ChangeNotifier {
  final List<Product> _products = List.of(MockData.featuredProducts);

  List<Product> get products => List.unmodifiable(_products);

  void updateProduct(String id, Product updated) {
    final index = _products.indexWhere((e) => e.id == id);

    if (index == -1) return;

    _products[index] = updated;
    notifyListeners();
  }

// Lấy sản phẩm theo danh mục — dùng cho màn chia mục
List<Product> byCategory(String categoryId) =>
    _products.where((e) => e.categoryId == categoryId).toList();

// Thêm sản phẩm mới
void addProduct(Product product) {
  _products.add(product);
  notifyListeners();
}

// Xoá sản phẩm
void deleteProduct(String id) {
  _products.removeWhere((e) => e.id == id);
  notifyListeners();
}
}