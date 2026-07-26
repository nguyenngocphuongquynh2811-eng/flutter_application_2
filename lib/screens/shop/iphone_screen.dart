import 'package:flutter/material.dart';

class IphoneScreen extends StatelessWidget {
  const IphoneScreen({super.key});

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
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
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
                "Mua iPhone",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),

          // DANH SÁCH SẢN PHẨM IPHONE (Vuốt ngang)
          SliverToBoxAdapter(
            child: _iphoneHeroCarousel(),
          ),

          // BANNER ĐỔI CŨ LẤY MỚI
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sync_alt, color: Colors.blueAccent, size: 30),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Text(
                        "Đổi thiết bị đủ điều kiện của bạn lấy điểm tín dụng cho lần mua hàng tiếp theo.",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white54),
                  ],
                ),
              ),
            ),
          ),

          _sectionTitle("Tìm hiểu sâu hơn"),
          
          // SO SÁNH CÁC PHIÊN BẢN
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
                      child: Image.asset(
                        "assets/images/iphone16.jpg", // Nhớ thêm hình này
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
                              "Xem iPhone nào phù hợp với bạn.",
                              style: TextStyle(color: Colors.white54, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          _sectionTitle("Xem cập nhật mới về iPhone"),

          // TÍNH NĂNG MỚI CAROUSEL
          SliverToBoxAdapter(
            child: _featureCarousel(),
          ),

          _sectionTitle("Dễ dàng thiết lập"),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  const Text(
                    "Chuyển ảnh, danh bạ, tệp và nhiều dữ liệu khác chỉ trong vài bước đơn giản.",
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

          // PHỤ KIỆN CAROUSEL
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
                        _pillButton("Tất Cả Phụ Kiện Máy iPhone"),
                        _pillButton("Ốp Lưng & Vỏ Bảo Vệ"),
                        _pillButton("MagSafe"),
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
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 80),
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

  Widget _iphoneHeroCarousel() {
    final iphones = [
      {
        "image": "assets/images/iphone17.jpg",
        "colors": [Colors.orange, Colors.blueGrey, Colors.white],
        "name": "iPhone 17 Pro",
        "desc": "Thiết kế sáng tạo cho hiệu năng và thời lượng pin cực đỉnh.",
        "price": "Từ 34.999.000đ hoặc 1.425.000đ/th. trong 24 tháng"
      },
      {
        "image": "assets/images/iphone.jpg",
        "colors": [Colors.white, Colors.black, Colors.grey],
        "name": "iPhone Air",
        "desc": "iPhone mỏng nhất từng có. Với sức mạnh pro bên trong.",
        "price": "Từ 31.999.000đ hoặc 1.303.000đ/th. trong 24 tháng"
      },
      {
        "image": "assets/images/iphone17.jpg",
        "colors": [Colors.purpleAccent, Colors.green, Colors.blue, Colors.white, Colors.black],
        "name": "iPhone 17",
        "desc": "Thú vị hơn hẳn. Bền bỉ hơn hẳn.",
        "price": "Từ 24.999.000đ hoặc 1.018.000đ/th. trong 24 tháng"
      }
    ];

    return SizedBox(
      height: 680,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: iphones.length,
        itemBuilder: (context, index) {
          final phone = iphones[index];
          final colors = phone["colors"] as List<Color>;

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
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(32),
                    image: DecorationImage(
                      image: AssetImage(phone["image"] as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Chấm màu
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
                  phone["name"] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  phone["desc"] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
                ),
                const SizedBox(height: 15),
                
                // Giá
                Text(
                  phone["price"] as String,
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

  Widget _featureCarousel() {
    return SizedBox(
      height: 480,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          Container(
            width: 320,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF), // Màu nền sáng cho thẻ Apple Intelligence
              borderRadius: BorderRadius.circular(28),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Apple Intelligence", style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                  "Viết lách, thể hiện bản thân và hoàn thành công việc dễ dàng.",
                  style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
                ),
              ],
            ),
          ),
          Container(
            width: 320,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                      image: DecorationImage(
                        image: AssetImage("assets/images/iphone.jpg"), // Hình thiết bị
                        fit: BoxFit.cover,
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("TÀI CHÍNH", style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("Thanh toán hàng tháng thật dễ dàng. Bao gồm lựa chọn lãi suất 0%.", 
                        style: TextStyle(color: Colors.black54, fontSize: 18)),
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
      {"image": "assets/images/iphone.jpg", "name": "Ốp Lưng Silicon MagSafe cho iPhone 17 Pro - Kem Vani", "price": "1.403.000đ"},
      {"image": "assets/images/iphone.jpg", "name": "Dây Đeo Chéo - Hồng Phai", "price": "1.668.000đ"},
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
                const Text("Mới", style: TextStyle(color: Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
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