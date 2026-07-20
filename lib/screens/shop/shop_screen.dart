import 'package:flutter/material.dart';
import '../profile/account_bottom_sheet.dart';
import '/../widgets/profile_avatar.dart';
import '../../data/mock_data.dart';



class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

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
              child: _productCategories(),
            ),

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
              child: _newProductsSection(
              ),
            ),

            _sectionTitle("Apple Store tạo nên mọi khác biệt"),

            SliverToBoxAdapter(
              child: _horizontalCards(
                [
                  (
                    "assets/images/emoji.jpg",
                    "Thêm dấu ấn của riêng bạn",
                    "Khắc tên miễn phí."
                  ),
                  (
                    "assets/images/tradein.jpg",
                    "Trade In",
                    "Đổi cũ lấy mới."
                  ),
                ],
              ),
            ),

            _sectionTitle("Mua cho các thiết bị của bạn"),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      "Bật Thiết Bị và Dịch Vụ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            _sectionTitle("Tận hưởng trải nghiệm đến từ Apple"),

            SliverToBoxAdapter(
              child: _horizontalCards(
                [
                  (
                    "assets/images/music.jpg",
                    "Apple Music",
                    "Tặng 3 tháng miễn phí."
                  ),
                  (
                    "assets/images/fitness.jpg",
                    "Fitness+",
                    "Tập luyện mọi lúc."
                  ),
                ],
              ),
            ),

            _sectionTitle("Bạn cần trợ giúp đưa ra quyết định?"),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/specialist.png",
                        height: 180,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Mua sắm cùng Chuyên Gia theo cách thuận tiện với bạn.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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

  static Widget _productCategories() {
    final items = [
      ("iphone.jpg", "iPhone"),
      ("watch.jpg", "Apple Watch"),
      ("ipad.jpg", "iPad"),
      ("mac.jpg", "Mac"),
      ("airpods.jpg", "AirPods"),
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, index) {
          return Container(
            width: 110,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/${items[index].$1}",
                  height: 50,
                ),
                const SizedBox(height: 15),
                Text(
                  items[index].$2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                )
              ],
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
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
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

  static Widget _horizontalCards(List<(String, String, String)> items) {
    return SizedBox(
      height: 520,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];

          return Container(
            width: 320,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    item.$1,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$2,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.$3,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
  static Widget _newProductsSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22),
    child: Column(
      children: [
        // CARD LỚN
        ...MockData.bigCards.map((product) {
          final isDark = ThemeData.estimateBrightnessForColor(
                product.backgroundColor,
              ) ==
              Brightness.dark;

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
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                    ),
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
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
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
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.price,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),

                                  if (product.priceNote != null)
                                    Text(
                                      product.priceNote!,
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.white60,
                                        fontSize: 13,
                                      ),
                                    ),
                                ],
                              ),

                              ElevatedButton(
                                onPressed: () {},
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white,
                                  foregroundColor:
                                      Colors.black,
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(30),
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

        // CARD NHỎ
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: MockData.smallCards.length,
            itemBuilder: (context, index) {
              final product = MockData.smallCards[index];

              return Container(
                width: 250,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                  // ẢNH
                    Expanded(
                      flex: 7,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.center,
                        child: Image.asset(
                          product.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // THÔNG TIN
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(
                          18,
                          12,
                          18,
                          14,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color(0xFFEAEAEA),
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),
                            Text(
                              product.price,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),

                            const Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                 color: Colors.black,
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Mua",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
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
}