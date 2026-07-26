import 'package:flutter/material.dart';
import '../../screens/profile/account_bottom_sheet.dart';
import '../../widgets/profile_avatar.dart';
import '../../data/mock_data.dart';
import '../../screens/shop/apple_music_detail_screen.dart';
import '../../screens/shop/apple_fitness_detail_screen.dart';
import '../../data/cart_data.dart';
import 'admin_category_screen.dart';
import 'widgets/banner_widget.dart';

class AdminShopScreen extends StatelessWidget {
  const AdminShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 16,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sản Phẩm",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
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
            ),
          ),

          SliverToBoxAdapter(
            child: _productCategories(context),
          ),

          // BANNER sửa được — chỉ admin có
          const SliverToBoxAdapter(child: BannerWidget()),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(22, 30, 22, 15),
              child: Text(
                "Phụ kiện",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: _accessories(),
          ),

          _sectionTitle("Khám phá sản phẩm mới"),

          SliverToBoxAdapter(
            child: _newProductsSection(context),
          ),

          _sectionTitle("Apple Store tạo nên mọi khác biệt"),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _storeHighlights(),
            ),
          ),

          _sectionTitle("Mua cho các thiết bị của bạn."),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Xem các đề xuất, sản phẩm và phụ kiện tương thích với thiết bị bạn đang sở hữu.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Bật Thiết Bị và Dịch Vụ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          _sectionTitle("Tận hưởng trải nghiệm đến từ Apple"),

          Builder(
            builder: (context) => SliverToBoxAdapter(
              child: _horizontalCards(
                context,
                [
                  CardItemData(
                    image: "assets/images/apple_music.jpg",
                    title: "Tặng 3 tháng sử dụng Apple Music miễn phí.",
                    subtitle: "Đi kèm khi mua một số thiết bị Apple.⁺",
                    bgColor: const Color(0xFFF5F5F7),
                    textColor: Colors.black,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AppleMusicDetailScreen(),
                        ),
                      );
                    },
                  ),
                  CardItemData(
                    image: "assets/images/fitness.jpg",
                    title: "Apple Fitness+",
                    subtitle:
                        "Từ Thể Lực đến Thiền Định, ai cũng tìm được bài tập cho mình.",
                    bgColor: Colors.white,
                    textColor: Colors.black,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AppleFitnessDetailScreen(),
                        ),
                      );
                    },
                  ),
                  CardItemData(
                    image: "assets/images/icloud.jpg",
                    title: "Thêm nhiều lợi ích cùng iCloud+.",
                    subtitle:
                        "Nhận dung lượng lưu trữ bạn cần, cùng quyền riêng tư bạn đáng có. Nâng cấp gói iCloud+ ngay.¶",
                    bgColor: const Color(0xFF2463EB),
                    textColor: Colors.white,
                    onTap: () {},
                  ),
                  CardItemData(
                    image: "assets/images/apple_pay.jpg",
                    title: "Khám phá tất cả các cách sử dụng Apple Pay.",
                    subtitle: "Tìm hiểu thêm tại apple.com",
                    bgColor: Colors.white,
                    textColor: Colors.black,
                    onTap: () {},
                  ),
                  CardItemData(
                    image: "assets/images/apple_arcade.jpg",
                    overline: "Apple Arcade",
                    title: "Nhận 3 tháng miễn phí khi mua thiết bị Apple.**",
                    subtitle:
                        "Chơi hàng trăm game mà không bị gián đoạn bởi quảng cáo.",
                    bgColor: const Color(0xFF0F0F10),
                    textColor: Colors.white,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          const SliverPadding(
            padding: EdgeInsets.only(bottom: 120),
          ),
        ],
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 35, 22, 20),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ĐÃ SỬA: bấm chip mở màn quản lý CRUD của danh mục
  static Widget _productCategories(BuildContext context) {
    final items = [
      ("iphone.jpg", "iPhone", "c2"),
      ("watch.jpg", "Apple Watch", "c4"),
      ("ipad.jpg", "iPad", "c3"),
      ("mac.jpg", "Mac", "c1"),
      ("airpods.jpg", "AirPods", "c5"),
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              final cat = MockData.categories
                  .firstWhere((e) => e.id == items[index].$3);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminCategoryScreen(category: cat),
                ),
              );
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/${items[index].$1}",
                    height: 45,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    items[index].$2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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

  static Widget _accessories() {
    final accessories = [
      "Tất Cả Phụ Kiện",
      "MagSafe",
      "Dây Đeo Watch",
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: accessories.length,
        itemBuilder: (_, index) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                accessories[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _horizontalCards(
    BuildContext context,
    List<CardItemData> items,
  ) {
    return SizedBox(
      height: 500,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];

          return GestureDetector(
            onTap: item.onTap,
            child: Container(
              width: 300,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: item.bgColor,
                borderRadius: BorderRadius.circular(28),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Image.asset(
                        item.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.overline != null) ...[
                            Text(
                              item.overline!,
                              style: TextStyle(
                                fontSize: 13,
                                color: item.textColor.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                          Text(
                            item.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 22,
                              color: item.textColor,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.subtitle,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              color: item.textColor.withValues(alpha: 0.6),
                              height: 1.4,
                            ),
                          ),
                        ],
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

  static Widget _newProductsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          ...MockData.bigCards.map((product) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                height: 540,
                decoration: BoxDecoration(
                  color: product.backgroundColor,
                  borderRadius: BorderRadius.circular(32),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(product.image, fit: BoxFit.cover),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black87,
                              Colors.black54,
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.tag != null)
                              Text(
                                product.tag!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            const SizedBox(height: 6),
                            Text(
                              product.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.subtitle,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.price,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (product.priceNote != null)
                                      Text(
                                        product.priceNote!,
                                        style: const TextStyle(
                                          color: Colors.white60,
                                          fontSize: 13,
                                        ),
                                      ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text("Mua"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
          SizedBox(
            height: 450,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: MockData.smallCards.length,
              itemBuilder: (context, index) {
                final product = MockData.smallCards[index];
                return Container(
                  width: 330,
                  margin: const EdgeInsets.only(right: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: const Color(0xFFE5E5EA),
                      width: 1,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Image.asset(product.image, fit: BoxFit.contain),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Colors.black87,
                                Colors.black54,
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.tag != null)
                                Text(
                                  product.tag!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                product.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                product.subtitle,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.price,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          if (product.priceNote != null)
                                            Text(
                                              product.priceNote!,
                                              maxLines: 2,
                                              softWrap: true,
                                              style: const TextStyle(
                                                color: Colors.white60,
                                                fontSize: 11,
                                                height: 1.2,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(70, 40),
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(22),
                                        ),
                                      ),
                                      child: const Text(
                                        "Mua",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _storeHighlights() {
    final items = [
      (
        "assets/images/emoji.jpg",
        "Thêm dấu ấn của riêng bạn. Khắc kết hợp biểu tượng cảm xúc,\ntên và chữ số miễn phí.",
      ),
      (
        "assets/images/shipping.jpg",
        "Giao hàng miễn phí đến tận nơi",
      ),
    ];

    return SizedBox(
      height: 230,
      child: PageView.builder(
        itemCount: items.length,
        controller: PageController(viewportFraction: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Image.asset(item.$1, width: 60, height: 60),
                const SizedBox(height: 15),
                Text(
                  item.$2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Tìm hiểu thêm >",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

