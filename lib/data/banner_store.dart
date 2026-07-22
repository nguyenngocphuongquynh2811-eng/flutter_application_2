import 'package:flutter/material.dart';

import '../models/admin/banner_model.dart';


class BannerStore extends ChangeNotifier {

  final List<BannerModel> _banners = [

    const BannerModel(
      imagePath: "assets/images/iphone16.jpg",
      title: "iPhone 16 Pro",
      subtitle: "Apple Intelligence",
    ),

    const BannerModel(
      imagePath: "assets/images/macbook.jpg",
      title: "MacBook Pro",
      subtitle: "Powerful Performance",
    ),

    const BannerModel(
      imagePath: "assets/images/ipad.jpg",
      title: "iPad Pro M4",
      subtitle: "Thin and powerful",
    ),

  ];


  List<BannerModel> get banners =>
      _banners;


  void addBanner(
      BannerModel banner) {

    _banners.add(banner);

    notifyListeners();
  }


  void updateBanner(
      int index,
      BannerModel banner) {

    _banners[index] = banner;

    notifyListeners();
  }


  void deleteBanner(
      int index) {

    _banners.removeAt(index);

    notifyListeners();
  }
}