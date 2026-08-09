import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/admin/promotion_model.dart';

class PromotionStore extends ChangeNotifier {
  final _collection = FirebaseFirestore.instance.collection('promotions');

  List<PromotionModel> _promotions = [];
  bool _isLoaded = false;
  String? _error;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  PromotionStore() {
    _subscription = _collection.orderBy('createdAt', descending: true).snapshots().listen(
      (snap) {
        _promotions = snap.docs.map((d) => _fromDoc(d.id, d.data())).toList();
        _isLoaded = true;
        _error = null;
        notifyListeners();
      },
      onError: (Object e) {
        _error = e.toString();
        _isLoaded = true;
        notifyListeners();
      },
    );
  }

  List<PromotionModel> get promotions => List.unmodifiable(_promotions);
  bool get isLoaded => _isLoaded;
  String? get error => _error;

  Future<void> addPromotion(PromotionModel promo) async {
    await _collection.add({..._toMap(promo), 'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> updatePromotion(String id, PromotionModel promo) async {
    await _collection.doc(id).set(_toMap(promo), SetOptions(merge: true));
  }

  Future<void> deletePromotion(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> setActive(String id, bool isActive) async {
    await _collection.doc(id).set({'isActive': isActive}, SetOptions(merge: true));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Map<String, dynamic> _toMap(PromotionModel p) => {
        'title': p.title,
        'description': p.description,
        'code': p.code,
        'discountPercent': p.discountPercent,
        'imagePath': p.imagePath,
        'isActive': p.isActive,
      };

  PromotionModel _fromDoc(String id, Map<String, dynamic> data) => PromotionModel(
        id: id,
        title: data['title'] as String? ?? '',
        description: data['description'] as String? ?? '',
        code: data['code'] as String? ?? '',
        discountPercent: (data['discountPercent'] as num?)?.toDouble() ?? 0,
        imagePath: data['imagePath'] as String? ?? '',
        isActive: data['isActive'] as bool? ?? true,
      );
}
