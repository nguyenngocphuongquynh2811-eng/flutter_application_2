import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/admin/banner_model.dart';

const _seedBanners = [
  BannerModel(
    imagePath: "assets/images/iphone16.jpg",
    title: "iPhone 16 Pro",
    subtitle: "Apple Intelligence",
  ),
  BannerModel(
    imagePath: "assets/images/macbook.jpg",
    title: "MacBook Pro",
    subtitle: "Powerful Performance",
  ),
  BannerModel(
    imagePath: "assets/images/ipad.jpg",
    title: "iPad Pro M4",
    subtitle: "Thin and powerful",
  ),
];

class BannerStore extends ChangeNotifier {
  final _collection = FirebaseFirestore.instance.collection('banners');

  List<BannerModel> _banners = [];
  List<String> _ids = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  BannerStore() {
    _init();
  }

  List<BannerModel> get banners => List.unmodifiable(_banners);

  Future<void> _init() async {
    try {
      final snapshot = await _collection.limit(1).get();
      if (snapshot.docs.isEmpty) {
        for (final banner in _seedBanners) {
          await _collection.add({..._toMap(banner), 'createdAt': FieldValue.serverTimestamp()});
        }
      }
    } catch (_) {
      // A non-admin account may not have permission to seed the shared
      // banner list; that's fine, the snapshot listener below still works
      // once another session (or an admin) has written the first banner.
    }

    _subscription = _collection.orderBy('createdAt').snapshots().listen(
      (snap) {
        _banners = snap.docs.map((d) => _fromMap(d.data())).toList();
        _ids = snap.docs.map((d) => d.id).toList();
        notifyListeners();
      },
      onError: (Object e) {
        // Don't crash the app on a stream error (e.g. permission-denied).
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> addBanner(BannerModel banner) async {
    await _collection.add({..._toMap(banner), 'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> updateBanner(int index, BannerModel banner) async {
    if (index < 0 || index >= _ids.length) return;
    await _collection.doc(_ids[index]).set(_toMap(banner), SetOptions(merge: true));
  }

  Future<void> deleteBanner(int index) async {
    if (index < 0 || index >= _ids.length) return;
    await _collection.doc(_ids[index]).delete();
  }

  Map<String, dynamic> _toMap(BannerModel b) => {
        'imagePath': b.imagePath,
        'title': b.title,
        'subtitle': b.subtitle,
      };

  BannerModel _fromMap(Map<String, dynamic> data) => BannerModel(
        imagePath: data['imagePath'] as String? ?? '',
        title: data['title'] as String? ?? '',
        subtitle: data['subtitle'] as String? ?? '',
      );
}
