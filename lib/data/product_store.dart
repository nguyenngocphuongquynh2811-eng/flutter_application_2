import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';
import 'mock_data.dart';

/// ProductStore dùng Firestore: admin thêm/sửa/xóa -> ghi lên Firebase ->
/// khách và mọi máy thấy real-time, tắt app không mất.
class ProductStore extends ChangeNotifier {
  final CollectionReference<Map<String, dynamic>> _col =
      FirebaseFirestore.instance.collection('products');

  List<Product> _products = [];

  ProductStore() {
    // Lắng nghe real-time: Firestore đổi -> UI tự cập nhật.
    _col.snapshots().listen((snap) {
      _products =
          snap.docs.map((d) => Product.fromMap(d.id, d.data())).toList();
      notifyListeners();
    });
  }

  List<Product> get products => List.unmodifiable(_products);

  List<Product> byCategory(String categoryId) =>
      _products.where((e) => e.categoryId == categoryId).toList();

  // Dùng doc(id) để giữ nguyên id sinh ra từ form (p{timestamp}).
  Future<void> addProduct(Product p) => _col.doc(p.id).set(p.toMap());

  Future<void> updateProduct(String id, Product p) =>
      _col.doc(id).set(p.toMap());

  Future<void> deleteProduct(String id) => _col.doc(id).delete();

  /// Đẩy dữ liệu mẫu lên Firestore MỘT LẦN (nếu collection đang trống).
  /// Gọi khi đang đăng nhập admin (vì rules chỉ cho admin ghi).
  Future<void> seedIfEmpty() async {
    final existing = await _col.limit(1).get();
    if (existing.docs.isNotEmpty) return;
    for (final p in MockData.featuredProducts) {
      await _col.doc(p.id).set(p.toMap());
    }
  }
}
