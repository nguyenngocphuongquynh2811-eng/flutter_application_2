import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 10),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Sản Phẩm",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(
                        "assets/images/avatar.jpg",
                      ),
                    )
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
                    fontSize: 28,
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
              child: _horizontalCards(
                [
                  (
                    "assets/images/macbook.jpg",
                    "MacBook Neo",
                    "Điều tuyệt diệu của Mac ở mức giá bất ngờ."
                  ),
                  (
                    "assets/images/airpodsmax.jpg",
                    "AirPods Max",
                    "Âm thanh đỉnh cao."
                  ),
                ],
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
            fontSize: 30,
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
      height: 170,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, index) {
          return Container(
            width: 150,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/${items[index].$1}",
                  height: 70,
                ),
                const SizedBox(height: 15),
                Text(
                  items[index].$2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
      height: 60,
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
                  fontSize: 17,
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
}