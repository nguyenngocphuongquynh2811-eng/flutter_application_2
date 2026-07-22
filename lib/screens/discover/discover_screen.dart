import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../widgets/profile_avatar.dart';
import '../profile/account_bottom_sheet.dart';
import '../shop/apple_music_detail_screen.dart';
import '../shop/apple_fitness_detail_screen.dart';
import '../shop/apple_icloud_detail_screen.dart';
import '../shop/apple_pay_detail_screen.dart';
import '../shop/apple_arcade_detail_screen.dart';

const _kCardColor = Color(0xFF1C1C1E);
const _kSecondaryText = Color(0xFF98989D);

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  static Widget? _detailScreenFor(String image) {
    switch (image) {
      case 'assets/images/apple_music.jpg':
        return const AppleMusicDetailScreen();
      case 'assets/images/apple_fitness.jpg':
        return const AppleFitnessDetailScreen();
      case 'assets/images/icloud.jpg':
        return const AppleICloudDetailScreen();
      case 'assets/images/apple_pay.jpg':
        return const ApplePayDetailScreen();
      case 'assets/images/apple_arcade.jpg':
        return const AppleArcadeDetailScreen();
      default:
        return null;
    }
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(label),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF2C2C2E),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 40),
          children: [
            _header(context),
            const SizedBox(height: 20),
            _heroCard(),
            const SizedBox(height: 36),
            _sectionTitle('Dịch vụ được đề xuất cho bạn'),
            const SizedBox(height: 16),
            _servicesCarousel(context),
            const SizedBox(height: 36),
            _deviceSupportSection(context),
            const SizedBox(height: 36),
            _sectionTitle('Đề xuất cho iPhone 12 Pro của bạn'),
            const SizedBox(height: 16),
            _productsCarousel(),
            const SizedBox(height: 36),
            _categoryList(context),
            const SizedBox(height: 24),
            _icloudBanner(context),
          ],
        ),
      ),
    );
  }

  // ---------- HEADER ----------

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Xem Thêm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => const AccountBottomSheet(),
              );
            },
            child: const ProfileAvatar(),
          ),
        ],
      ),
    );
  }

  // ---------- HERO CARD ----------

  Widget _heroCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tận dụng tối đa iPhone của bạn',
            style: TextStyle(color: _kSecondaryText, fontSize: 15),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                Container(
                  height: 170,
                  width: double.infinity,
                  color: const Color(0xFF2C2C2E),
                  child: const _IosFeatureCollage(),
                ),
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF2F2F2),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bạn có biết mình có thể dùng iPhone theo cách đó?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Khám phá các mẹo nhỏ về Tin nhắn, Màn hình khóa và Ảnh giúp bạn dùng iPhone hiệu quả hơn mỗi ngày.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- SECTION TITLE ----------

  Widget _sectionTitle(String title, {bool withChevron = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (withChevron)
            const Icon(Icons.chevron_right_rounded, color: _kSecondaryText),
        ],
      ),
    );
  }

  // ---------- SERVICES CAROUSEL ----------

  Widget _servicesCarousel(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        scrollDirection: Axis.horizontal,
        itemCount: MockData.promoCards.length,
        itemBuilder: (_, index) {
          final item = MockData.promoCards[index];
          final screen = _detailScreenFor(item.image);
          return GestureDetector(
            onTap: screen == null
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => screen),
                    );
                  },
            child: Container(
              width: 220,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(item.image, fit: BoxFit.cover, width: double.infinity),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------- DEVICE SUPPORT ----------

  Widget _deviceSupportSection(BuildContext context) {
    return Column(
      children: [
        _sectionTitle('Hỗ trợ cho thiết bị của bạn', withChevron: true),
        const SizedBox(height: 20),
        Image.asset(
          'assets/images/Iphone15.jpg',
          height: 180,
        ),
        const SizedBox(height: 14),
        const Text(
          'Cái quần jz',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'iPhone 12 Pro',
          style: TextStyle(color: _kSecondaryText, fontSize: 13),
        ),
        const SizedBox(height: 22),
        GestureDetector(
          onTap: () => _showComingSoon(context, 'Đang mở Hỗ Trợ Của Apple...'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF48484A),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.build_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Tìm kiếm các tùy chọn khác tại phần Hỗ Trợ Của Apple',
                    style: TextStyle(color: Colors.white, fontSize: 14, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------- PRODUCTS CAROUSEL ----------

  Widget _productsCarousel() {
    final products = [
      (Icons.cable, Colors.redAccent, 'Cáp Sạc USB-C', '519.000đ'),
      (Icons.cable, Colors.white70, 'Dây Cáp Sạc', '390.000đ'),
      (Icons.gps_fixed, Colors.white70, 'AirTag', '890.000đ'),
    ];

    return SizedBox(
      height: 200,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (_, index) {
          final product = products[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _kCardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.bookmark_border_rounded, color: _kSecondaryText, size: 20),
                ),
                Expanded(
                  child: Center(
                    child: Icon(product.$1, color: product.$2, size: 48),
                  ),
                ),
                Text(
                  product.$3,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.$4,
                  style: const TextStyle(color: _kSecondaryText, fontSize: 13),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------- CATEGORY LIST ----------

  Widget _categoryList(BuildContext context) {
    final categories = [
      (Icons.gps_fixed, 'AirTag và Các Phụ Kiện'),
      (Icons.bolt, 'MagSafe'),
      (Icons.favorite_outline, 'Sức khỏe'),
      (Icons.headphones, 'Tai nghe'),
      (Icons.power, 'Sạc'),
      (Icons.phone_iphone, 'Ốp lưng'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        decoration: BoxDecoration(
          color: _kCardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: List.generate(categories.length, (index) {
            final category = categories[index];
            final isLast = index == categories.length - 1;
            return GestureDetector(
              onTap: () => _showComingSoon(context, category.$2),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : const Border(
                          bottom: BorderSide(color: Colors.white12, width: 0.6),
                        ),
                ),
                child: Row(
                  children: [
                    Icon(category.$1, color: Colors.white, size: 20),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        category.$2,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: _kSecondaryText),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ---------- ICLOUD BANNER ----------

  Widget _icloudBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _kCardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.cloud_rounded, color: Colors.blueAccent, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dung lượng iCloud của bạn gần đầy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Sao lưu và ảnh của bạn có thể ngừng đồng bộ nếu dung lượng iCloud đầy.',
                    style: TextStyle(color: _kSecondaryText, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AppleICloudDetailScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Nâng cấp lên iCloud+',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small collage of rounded tiles standing in for iOS feature screenshots
/// (Messages, Lock Screen, Photos) since we don't have real screenshot assets.
class _IosFeatureCollage extends StatelessWidget {
  const _IosFeatureCollage();

  @override
  Widget build(BuildContext context) {
    final tiles = [
      (Icons.chat_bubble_rounded, const Color(0xFF32D74B)),
      (Icons.lock_outline_rounded, const Color(0xFF0A84FF)),
      (Icons.photo_rounded, const Color(0xFFFF9F0A)),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: tiles
            .map(
              (tile) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: tile.$2,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Icon(tile.$1, color: Colors.white, size: 30),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
