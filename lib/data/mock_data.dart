import '../models/product.dart';
import '../models/category.dart';
import '../models/promo_card.dart';
import '../models/shop_card.dart';
import 'package:flutter/material.dart';

class MockData {
  static const List<Category> categories = [
    Category(id: 'c1', name: 'Mac', imagePath: 'assets/images/mac_cat.jpg'),
    Category(id: 'c2', name: 'iPhone', imagePath: 'assets/images/Iphone15.jpg'),
    Category(id: 'c3', name: 'iPad', imagePath: 'assets/images/ipad_cat.jpg'),
    Category(id: 'c4', name: 'Watch', imagePath: 'assets/images/watch_cat.jpg'),
    Category(id: 'c5', name: 'AirPods', imagePath: 'assets/images/airpods_cat.jpg'),
  ];

  static const List<Product> featuredProducts = [
    Product(
      id: 'p1',
      name: 'iPhone 15 Pro',
      description: 'Titanium. So strong. So light. So Pro. The most advanced iPhone ever made.',
      price: 34000000,
      imagePaths: [
        'assets/images/iphone15_1.jpg',
        'assets/images/iphone15_2.jpg'
      ],
      categoryId: 'c2',
      tag: 'New',
    ),
    Product(
      id: 'p2',
      name: 'MacBook Pro 14"',
      description: 'Mind-blowing. Head-turning. Powered by the M3 chip.',
      price: 51000000,
      imagePaths: [
        'assets/images/macbook_pro.jpg',
      ],
      categoryId: 'c1',
      tag: 'Bestseller',
    ),
    Product(
      id: 'p3',
      name: 'Apple Watch Ultra 2',
      description: 'Next-level adventure. The most rugged and capable Apple Watch pushes the limits again.',
      price: 17000000,
      imagePaths: [
        'assets/images/watch_ultra.jpg',
      ],
      categoryId: 'c4',
      tag: 'New',
    ),
    Product(
      id: 'p4',
      name: 'iPad Pro',
      description: 'The ultimate iPad experience with the most advanced display, M2 chip, and Apple Pencil hover.',
      price: 25000000,
      imagePaths: [
        'assets/images/ipad_pro.jpg',
      ],
      categoryId: 'c3',
      tag: 'Popular',
    ),
    Product(
      id: 'p5',
      name: 'MacBook Air M3',
      description: 'Lean. Mean. M3 machine.',
      price: 21000000,
      imagePaths: [
        'assets/images/mac_cat.jpg',
      ],
      categoryId: 'c1',
      tag: 'New',
    ),
    Product(
      id: 'p6',
      name: 'iPhone 15',
      description: 'New camera. New design. Newphoria.',
      price: 28000000,
      imagePaths: [
        'assets/images/iphone15_3.jpg',
      ],
      categoryId: 'c2',
      tag: 'Popular',
    ),
    Product(
      id: 'p7',
      name: 'Apple Watch Series 9',
      description: 'Smarter. Brighter. Mightier.',
      price: 15000000,
      imagePaths: [
        'assets/images/watch_cat.jpg',
      ],
      categoryId: 'c4',
      tag: 'Popular',
    ),
    Product(
      id: 'p8',
      name: 'AirPods Pro 2',
      description: 'Magic remastered.',
      price: 2500000,
      imagePaths: [
        'assets/images/airpods_cat.jpg',
      ],
      categoryId: 'c5',
      tag: 'Bestseller',
    ),
    Product(
      id: 'p9',
      name: 'AirPods Pro 3',
      description: 'Magic remastered.',
      price: 3500000,
      imagePaths: [
        'assets/images/airpodpro.jpg',
      ],
      categoryId: 'c5',
      tag: 'Bestseller',
    ),
  ];

   static const List<PromoCard> promoCards = [
    PromoCard(
      image: 'assets/images/apple_music.jpg',
      category: '',
      title: 'Tặng 3 tháng sử dụng Apple Music miễn phí.',
      subtitle: 'Đi kèm khi mua một số thiết bị Apple.',
    ),

    PromoCard(
      image: 'assets/images/apple_fitness.jpg',
      category: '',
      title: 'Apple Fitness+',
      subtitle: 'Từ Thể Lực đến Thiền Định, ai cũng tìm được bài tập cho mình.',
    ),

    PromoCard(
      image: 'assets/images/icloud.jpg',
      category: '',
      title: 'Thêm nhiều lợi ích cùng iCloud+.',
      subtitle: 'Nhận dung lượng lưu trữ bạn cần, cùng quyền riêng tư bạn đáng có. Nâng cấp gói iCloud+ ngay.',
    ),

    PromoCard(
      image: 'assets/images/apple_pay.jpg',
      category: '',
      title: 'Khám phá tất cả các cách sử dụng Apple Pay.',
      subtitle: 'Tìm hiểu thêm tại apple.com',
    ),

    PromoCard(
      image: 'assets/images/apple_arcade.jpg',
      category: 'Apple Arcade',
      title: 'Nhận 3 tháng miễn phí khi mua thiết bị Apple.',
      subtitle: 'Chơi hàng trăm game mà không bị gián đoạn bởi quảng cáo.',
    ),
  ];
  
  static const List<ShopCard> bigCards = [
  ShopCard(
    image: "assets/images/macbook_neo.jpg",
    title: "MacBook Neo",
    subtitle: "Điều tuyệt diệu của Mac.",
    price: "Từ 24.999.000đ",
    priceNote: "hoặc 1.041.625đ/th. trong 24 tháng",
    tag: "Mới",
    backgroundColor: Colors.white,
  ),

  ShopCard(
    image: "assets/images/iphone17.jpg",
    title: "iPhone 17",
    subtitle: "Mạnh mẽ với chip M4.",
    price: "Từ 27.999.000đ",
    priceNote: "hoặc 1.166.625đ/th. trong 24 tháng",
    tag: "Mới",
    backgroundColor: Colors.black,
  ),
];

static const List<ShopCard> smallCards = [
  ShopCard(
    image: "assets/images/airpodsmax.jpg",
    title: "AirPods Max",
    subtitle: "Âm thanh đỉnh cao.",
    price: "13.499.000đ",
    backgroundColor: Colors.white,
  ),

  ShopCard(
    image: "assets/images/airpods.jpg",
    title: "AirPods Pro",
    subtitle: "Âm thanh không gian.",
    price: "5.999.000đ",
    backgroundColor: Colors.white,
  ),

  ShopCard(
    image: "assets/images/watch.jpg",
    title: "Apple Watch",
    subtitle: "Theo dõi sức khỏe.",
    price: "9.999.000đ",
    backgroundColor: Colors.white,
  ),
];
}
