import '../models/product.dart';
import '../models/category.dart';

class MockData {
  static const List<Category> categories = [
    Category(id: 'c1', name: 'Mac', imagePath: 'assets/images/mac_cat.jpg'),
    Category(id: 'c2', name: 'iPhone', imagePath: 'assets/images/iphone_cat.jpg'),
    Category(id: 'c3', name: 'iPad', imagePath: 'assets/images/ipad_cat.jpg'),
    Category(id: 'c4', name: 'Watch', imagePath: 'assets/images/watch_cat.jpg'),
    Category(id: 'c5', name: 'AirPods', imagePath: 'assets/images/airpods_cat.jpg'),
  ];

  static const List<Product> featuredProducts = [
    Product(
      id: 'p1',
      name: 'iPhone 15 Pro',
      description: 'Titanium. So strong. So light. So Pro. The most advanced iPhone ever made.',
      price: 999.00,
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
      price: 1599.00,
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
      price: 799.00,
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
      price: 1099.00,
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
      price: 1099.00,
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
      price: 799.00,
      imagePaths: [
        'assets/images/iphone_cat.jpg',
      ],
      categoryId: 'c2',
      tag: '',
    ),
    Product(
      id: 'p7',
      name: 'Apple Watch Series 9',
      description: 'Smarter. Brighter. Mightier.',
      price: 399.00,
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
      price: 249.00,
      imagePaths: [
        'assets/images/airpods_cat.jpg',
      ],
      categoryId: 'c5',
      tag: 'Bestseller',
    ),
  ];
}
