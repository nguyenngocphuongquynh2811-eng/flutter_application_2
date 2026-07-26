import 'package:flutter/material.dart';

class AppleWatchScreen extends StatelessWidget {
  const AppleWatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          // APP BAR
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black.withOpacity(0.9),
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1C1E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 18, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 24, bottom: 16),
              title: Text(
                "Mua Apple Watch",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),

          // DANH SÁCH SẢN PHẨM APPLE WATCH (Series 11, SE 3, Ultra 3)
          SliverToBoxAdapter(
            child: _watchHeroCarousel(),
          ),

          _sectionTitle("Tìm hiểu sâu hơn"),
          
          // SO SÁNH & DÂN CHẠY BỘ
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Card So Sánh
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
                          child: Image.asset(
                            "assets/images/watch_cat.jpg", // Thay bằng hình 3 chiếc đồng hồ
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "So sánh tất cả các\nphiên bản",
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Xem Apple Watch nào phù hợp với bạn tại apple.com.",
                                  style: TextStyle(color: Colors.white54, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Card Dân Chạy Bộ
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
                          child: Image.asset(
                            "assets/images/watch.jpg", // Thay bằng hình người chạy bộ
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Apple Watch cho dân chạy bộ.",
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Được thiết kế để khích lệ dân chạy bộ.",
                                  style: TextStyle(color: Colors.white54, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          _sectionTitle("Tiết kiệm với Apple"),

          // TIẾT KIỆM (Đổi cũ lấy mới)
          SliverToBoxAdapter(
            child: _savingsCarousel(),
          ),

          _sectionTitle("Dễ dàng thiết lập"),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  const Icon(Icons.important_devices_rounded, color: Colors.deepOrange, size: 45),
                  const SizedBox(height: 20),
                  const Text(
                    "Chuyển dữ liệu sang Apple Watch mới bằng iPhone.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Tìm hiểu thêm >", style: TextStyle(color: Colors.white, fontSize: 16)),
                  )
                ],
              ),
            ),
          ),

          _sectionTitle("Tìm mảnh ghép hoàn hảo\nvới bạn >"),

          // PHỤ KIỆN CAROUSEL (Dây đeo)
          SliverToBoxAdapter(
            child: _accessoriesCarousel(),
          ),

          // DUYỆT XEM PHỤ KIỆN (Pills)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Duyệt xem tất cả phụ kiện\nthiết yếu",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _pillButton("Tất Cả Phụ Kiện Cho Apple Watch"),
                        _pillButton("Dây Đeo Apple Watch"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // TRỢ GIÚP
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Vẫn cần trợ giúp trước khi\nquyết định?",
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1C1C1E),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.phone, color: Colors.blueAccent, size: 40),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Trò chuyện với\nchúng tôi qua\nđiện thoại",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 45, 24, 20),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  Widget _pillButton(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 15)),
      ),
    );
  }

  Widget _watchHeroCarousel() {
    final watches = [
      {
        "image": "assets/images/watch_cat.jpg",
        "colors": [Colors.grey, Colors.white, Colors.pink, Colors.black, Colors.brown, Colors.black87],
        "name": "Apple Watch Series 11",
        "desc": "Giải pháp tối thượng để theo dõi sức khỏe.",
        "price": "Từ 11.499.000đ hoặc 468.000đ/th. trong 24 tháng"
      },
      {
        "image": "assets/images/watch_cat.jpg",
        "colors": [Colors.blueGrey, Colors.white],
        "name": "Apple Watch SE 3",
        "desc": "Những tính năng sức khỏe thiết yếu với giá hấp dẫn.",
        "price": "Từ 6.999.000đ hoặc 285.000đ/th. trong 24 tháng"
      },
      {
        "image": "assets/images/watch_ultra.jpg",
        "colors": [Colors.grey, Colors.white],
        "name": "Apple Watch Ultra 3",
        "desc": "Chiếc đồng hồ tuyệt đỉnh cho thể thao và phiêu lưu.",
        "price": "Từ 23.999.000đ hoặc 977.000đ/th. trong 24 tháng"
      }
    ];

    return SizedBox(
      height: 680,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: watches.length,
        itemBuilder: (context, index) {
          final watch = watches[index];
          final colors = watch["colors"] as List<Color>;

          return Container(
            width: 340,
            margin: const EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hình ảnh sản phẩm
                Container(
                  height: 380,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7), // Màu nền sáng như trong hình mẫu
                    borderRadius: BorderRadius.circular(32),
                    image: DecorationImage(
                      image: AssetImage(watch["image"] as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Chấm màu swatches
                Row(
                  children: colors.map((c) => Container(
                    margin: const EdgeInsets.only(right: 6),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 15),
                
                // Tên và mô tả
                Text(
                  watch["name"] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  watch["desc"] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
                ),
                const SizedBox(height: 15),
                
                // Giá
                Text(
                  watch["price"] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 25),
                
                // Nút Mua & Tìm hiểu thêm
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Mua", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C1C1E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Tìm hiểu thêm", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _savingsCarousel() {
    return SizedBox(
      height: 480,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          Container(
            width: 320,
            decoration: BoxDecoration(
              color: const Color(0xFF7A7A7A), // Màu nền xám cho phần "Đổi cũ lấy mới"
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                      image: DecorationImage(
                        image: AssetImage("assets/images/watch_cat.jpg"), // Hình góc nghiêng Apple Watch
                        fit: BoxFit.contain,
                      )
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Đổi cũ lấy mới chưa bao giờ dễ dàng đến thế.", 
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, height: 1.2)),
                      SizedBox(height: 10),
                      Text("Tiết kiệm cho lần mua Apple Watch tiếp theo khi trao đổi thiết bị đang dùng. Dễ dàng thực hiện trực tuyến hoặc tại cửa hàng.", 
                        style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.4)),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _accessoriesCarousel() {
    final accessories = [
      {"image": "assets/images/watch.jpg", "name": "Dây Đeo Thể Thao Màu Cam Clementine 46mm - M/L", "price": "1.499.000đ"},
      {"image": "assets/images/watch.jpg", "name": "Dây Quấn Milan Màu Gold 46mm - M/L", "price": "2.999.000đ"},
    ];

    return SizedBox(
      height: 380,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: accessories.length,
        itemBuilder: (context, index) {
          final item = accessories[index];
          return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      Center(child: Image.asset(item["image"]!, height: 160)),
                      const Positioned(top: 15, right: 15, child: Icon(Icons.bookmark_border, color: Colors.white54)),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(item["name"]!, maxLines: 2, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 5),
                Text(item["price"]!, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          );
        },
      ),
    );
  }
}