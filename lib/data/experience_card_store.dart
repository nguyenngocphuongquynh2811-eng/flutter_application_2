import 'package:flutter/material.dart';

import 'cart_data.dart';

/// Quản lý các thẻ "Tận hưởng trải nghiệm đến từ Apple" (Apple Music, Fitness+,
/// iCloud+, Apple Pay, Apple Arcade...). Cùng mô hình với ShopCardStore.
class ExperienceCardStore extends ChangeNotifier {
  final List<CardItemData> _cards = [
    CardItemData(
      image: "assets/images/apple_music.jpg",
      title: "Tặng 3 tháng sử dụng Apple Music miễn phí.",
      subtitle: "Đi kèm khi mua một số thiết bị Apple.⁺",
      bgColor: const Color(0xFFF5F5F7),
      textColor: Colors.black,
    ),
    CardItemData(
      image: "assets/images/fitness.jpg",
      title: "Apple Fitness+",
      subtitle:
          "Từ Thể Lực đến Thiền Định, ai cũng tìm được bài tập cho mình.",
      bgColor: Colors.white,
      textColor: Colors.black,
    ),
    CardItemData(
      image: "assets/images/icloud.jpg",
      title: "Thêm nhiều lợi ích cùng iCloud+.",
      subtitle:
          "Nhận dung lượng lưu trữ bạn cần, cùng quyền riêng tư bạn đáng có. Nâng cấp gói iCloud+ ngay.¶",
      bgColor: const Color(0xFF2463EB),
      textColor: Colors.white,
    ),
    CardItemData(
      image: "assets/images/apple_pay.jpg",
      title: "Khám phá tất cả các cách sử dụng Apple Pay.",
      subtitle: "Tìm hiểu thêm tại apple.com",
      bgColor: Colors.white,
      textColor: Colors.black,
    ),
    CardItemData(
      image: "assets/images/apple_arcade.jpg",
      overline: "Apple Arcade",
      title: "Nhận 3 tháng miễn phí khi mua thiết bị Apple.**",
      subtitle:
          "Chơi hàng trăm game mà không bị gián đoạn bởi quảng cáo.",
      bgColor: const Color(0xFF0F0F10),
      textColor: Colors.white,
    ),
  ];

  List<CardItemData> get cards => List.unmodifiable(_cards);

  void addCard(CardItemData card) {
    _cards.add(card);
    notifyListeners();
  }

  void updateCard(int index, CardItemData card) {
    if (index < 0 || index >= _cards.length) return;
    _cards[index] = card;
    notifyListeners();
  }

  void deleteCard(int index) {
    if (index < 0 || index >= _cards.length) return;
    _cards.removeAt(index);
    notifyListeners();
  }
}
