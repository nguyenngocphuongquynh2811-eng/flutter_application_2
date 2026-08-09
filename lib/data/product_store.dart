import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';
import 'mock_data.dart';

class ProductStore extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _collection = FirebaseFirestore.instance.collection('products');

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
    try {
      final existing = await _collection.get();
      final existingIds = existing.docs.map((d) => d.id).toSet();
      final missing = [
        ...MockData.featuredProducts,
        ...MockData.accessoryProducts,
      ].where((p) => !existingIds.contains(p.id));

      if (missing.isNotEmpty) {
        final batch = _firestore.batch();
        for (final product in missing) {
          batch.set(_collection.doc(product.id), _toMap(product));
        }
        await batch.commit();
      }
    } catch (_) {
      // A non-admin account may not have permission to seed the shared
      // catalog; that's fine, the snapshot listener below still works
      // once another session (or an admin) has written the first product.
    }

    _subscription = _collection.snapshots().listen(
      (snap) {
        _products = snap.docs.map((d) => _fromDoc(d.id, d.data())).toList();
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

  Future<void> updateProduct(String id, Product updated) async {
    await _collection.doc(id).set(_toMap(updated));
  }

  Future<void> addProduct(Product product) async {
    await _collection.doc(product.id).set(_toMap(product));
  }

  Future<void> deleteProduct(String id) async {
    await _collection.doc(id).delete();
  }

  Map<String, dynamic> _toMap(Product p) => {
        'name': p.name,
        'description': p.description,
        'price': p.price,
        'imagePaths': p.imagePaths,
        'categoryId': p.categoryId,
        'tag': p.tag,
      };

  Product _fromDoc(String id, Map<String, dynamic> data) => Product(
        id: id,
        name: data['name'] as String? ?? '',
        description: data['description'] as String? ?? '',
        price: (data['price'] as num?)?.toDouble() ?? 0,
        imagePaths: List<String>.from(data['imagePaths'] as List? ?? const []),
        categoryId: data['categoryId'] as String? ?? '',
        tag: data['tag'] as String? ?? '',
      );
}
