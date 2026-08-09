import 'dart:async';

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
  bool _isLoaded = false;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  ProductStore() {
    _init();
  }

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoaded => _isLoaded;

  Future<void> _init() async {
    // Seed Firestore with the built-in catalog, one product at a time by its
    // fixed id, so a project that already has the original catalog still
    // picks up newly-added seed products (like accessories) on next launch
    // instead of only seeding once when the whole collection was empty.
    await seedIfEmpty();

    _subscription = _col.snapshots().listen(
      (snap) {
        _products = snap.docs.map((d) => Product.fromMap(d.id, d.data())).toList();
        _isLoaded = true;
        notifyListeners();
      },
      onError: (Object e) {
        // Don't crash the app on a stream error (e.g. permission-denied);
        // just stop showing the loading spinner.
        _isLoaded = true;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  List<Product> byCategory(String categoryId) =>
      _products.where((e) => e.categoryId == categoryId).toList();

  // Dùng doc(id) để giữ nguyên id sinh ra từ form (p{timestamp}).
  Future<void> addProduct(Product p) => _col.doc(p.id).set(p.toMap());

  Future<void> updateProduct(String id, Product p) => _col.doc(id).set(p.toMap());

  Future<void> deleteProduct(String id) => _col.doc(id).delete();

  /// Đẩy các sản phẩm mẫu còn thiếu lên Firestore theo id cố định — an toàn
  /// gọi nhiều lần (từ constructor lẫn từ AdminShell khi admin đăng nhập),
  /// và tự bỏ qua nếu tài khoản hiện tại không có quyền ghi.
  Future<void> seedIfEmpty() async {
    try {
      final existing = await _col.get();
      final existingIds = existing.docs.map((d) => d.id).toSet();
      final missing = [
        ...MockData.featuredProducts,
        ...MockData.accessoryProducts,
      ].where((p) => !existingIds.contains(p.id));

      if (missing.isEmpty) return;
      final batch = FirebaseFirestore.instance.batch();
      for (final product in missing) {
        batch.set(_col.doc(product.id), product.toMap());
      }
      await batch.commit();
    } catch (_) {
      // A non-admin/non-manager account may not have permission to seed the
      // shared catalog; that's fine, the snapshot listener still works once
      // another session (or staff) has written the first product.
    }
  }
}
