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
}