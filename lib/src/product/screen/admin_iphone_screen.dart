import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../sheet/edit_product_sheet.dart';
import '../../../data/product_store.dart';
import '../../../models/product.dart';
import '../../../widgets/product_image.dart';
import '../../product/admin_product_view_page.dart';
import '../../product/sheet/add_product_sheet.dart';

class AdminIphoneScreen extends StatelessWidget {
  const AdminIphoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black.withValues(alpha: 0.9),
            elevation: 0,
            actions: [
  IconButton(
    onPressed: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const AddProductSheet(categoryId: 'c2'),
      );
    },
    icon: Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add, size: 20, color: Colors.white),
    ),
  ),
  const SizedBox(width: 12),
],
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
                "Quản lý iPhone",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: _iphoneHeroCarousel(context)),

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
                  children: const [
                    Icon(Icons.sync_alt, color: Colors.blueAccent, size: 30),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "Đổi thiết bị đủ điều kiện của bạn lấy điểm tín dụng cho lần mua hàng tiếp theo.",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.white54),
                  ],
                ),
              ),
            ),
          ),

          _sectionTitle("Tìm hiểu sâu hơn"),

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
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(24)),
                      child: Image.asset(
                        "assets/images/iphone16.jpg",
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
                            Text("So sánh tất cả các\nphiên bản",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text("Xem iPhone nào phù hợp với bạn.",
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 14)),
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
          SliverToBoxAdapter(child: _featureCarousel()),

          _sectionTitle("Dễ dàng thiết lập"),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  const Text(
                    "Chuyển ảnh, danh bạ, tệp và nhiều dữ liệu khác chỉ trong vài bước đơn giản.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Tìm hiểu thêm >",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  )
                ],
              ),
            ),
          ),

          _sectionTitle("Tìm mảnh ghép hoàn hảo\nvới bạn >"),
          SliverToBoxAdapter(child: _accessoriesCarousel()),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text("Duyệt xem tất cả phụ kiện\nthiết yếu",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
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

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Vẫn cần trợ giúp trước khi\nquyết định?",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
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
                          child: const Icon(Icons.phone,
                              color: Colors.blueAccent, size: 40),
                        ),
                        const SizedBox(height: 15),
                        const Text("Trò chuyện với\nchúng tôi qua\nđiện thoại",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
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
        child: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5)),
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
        child: Text(text,
            style: const TextStyle(color: Colors.white, fontSize: 15)),
      ),
    );
  }

  // CAROUSEL SỬA ĐƯỢC — lấy iPhone từ ProductStore
  Widget _iphoneHeroCarousel(BuildContext context) {
    final phones = context.watch<ProductStore>().byCategory('c2');

    if (phones.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text('Chưa có iPhone nào. Bấm + để thêm.',
              style: TextStyle(color: Colors.white54, fontSize: 16)),
        ),
      );
    }

    return SizedBox(
      height: 560,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: phones.length,
        itemBuilder: (context, index) {
          final Product phone = phones[index];

          return Container(
            width: 340,
            margin: const EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context:context,
                    isScrollControlled: true,
                    builder: (_) => AdminProductViewPage(
                        product: phone, allProducts: phones),
                  ),
                  child: Container(
                    height: 360,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(32),
                      image: DecorationImage(
                        image: ProductImage.provider(phone.imagePaths.first),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                if (phone.tag.isNotEmpty)
                  Text(phone.tag,
                      style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(phone.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(phone.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 15, height: 1.4)),
                const SizedBox(height: 12),
                Text(
                  'Từ ${NumberFormat("#,###", "vi_VN").format(phone.price)}đ',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => AdminProductViewPage(
                            product: phone, allProducts: phones),
                      ),
                      icon: const Icon(Icons.edit, size: 18),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      label: const Text("Sửa",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: const Color(0xFF1C1C1E),
                            title: const Text('Xoá sản phẩm?',
                                style: TextStyle(color: Colors.white)),
                            content: Text('Xoá "${phone.name}"?',
                                style: const TextStyle(color: Colors.white70)),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Huỷ')),
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text('Xoá',
                                      style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        );
                        if (ok == true && context.mounted) {
                          context
                              .read<ProductStore>()
                              .deleteProduct(phone.id);
                        }
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C1C1E),
                        foregroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      label: const Text("Xoá",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
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
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(28),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Apple Intelligence",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                    "Viết lách, thể hiện bản thân và hoàn thành công việc dễ dàng.",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.2)),
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
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                      image: DecorationImage(
                        image: AssetImage("assets/images/iphone.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("TÀI CHÍNH",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                          "Thanh toán hàng tháng thật dễ dàng. Bao gồm lựa chọn lãi suất 0%.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 18)),
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
      {
        "image": "assets/images/iphone.jpg",
        "name": "Ốp Lưng Silicon MagSafe cho iPhone 17 Pro - Kem Vani",
        "price": "1.403.000đ"
      },
      {
        "image": "assets/images/iphone.jpg",
        "name": "Dây Đeo Chéo - Hồng Phai",
        "price": "1.668.000đ"
      },
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
                      const Positioned(
                          top: 15,
                          right: 15,
                          child: Icon(Icons.bookmark_border,
                              color: Colors.white54)),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Text("Mới",
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(item["name"]!,
                    maxLines: 2,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 5),
                Text(item["price"]!,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 14)),
              ],
            ),
          );
        },
      ),
    );
  }
}