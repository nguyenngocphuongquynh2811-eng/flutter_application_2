import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../data/product_store.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import 'package:flutter_application_2/widgets/product_image.dart';
import 'package:flutter_application_2/src/product/sheet/add_product_sheet.dart';
import 'package:flutter_application_2/src/product/sheet/edit_product_sheet.dart';

/// Trang Apple Watch DÙNG CHUNG cho khách và admin.
/// isAdmin = true: có nút + (thêm), bấm sản phẩm để sửa, nút xóa.
/// isAdmin = false: khách xem, nút "Mua". Cả hai đọc chung ProductStore.
class WatchPage extends StatelessWidget {
  final bool isAdmin;
  const WatchPage({super.key, this.isAdmin = false});

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
            pinned: true,
            backgroundColor: Colors.black.withValues(alpha: 0.9),
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Color(0xFF1C1C1E), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 18, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: isAdmin
                ? [
                    IconButton(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => const AddProductSheet(categoryId: 'c4'),
                      ),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: Color(0xFF1C1C1E), shape: BoxShape.circle),
                        child: const Icon(Icons.add,
                            size: 20, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ]
                : null,
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 24, bottom: 16),
              title: Text("Apple Watch",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5)),
            ),
          ),

          SliverToBoxAdapter(child: _heroCarousel(context)),

          _sectionTitle("Tìm hiểu sâu hơn"),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _infoCard("assets/images/watch_cat.jpg",
                      "So sánh tất cả các\nphiên bản",
                      "Xem Apple Watch nào phù hợp với bạn tại apple.com.",
                      bottomMargin: 16),
                  _infoCard("assets/images/watch.jpg",
                      "Apple Watch cho dân chạy bộ.",
                      "Được thiết kế để khích lệ dân chạy bộ."),
                ],
              ),
            ),
          ),

          _sectionTitle("Tiết kiệm với Apple"),
          SliverToBoxAdapter(child: _savingsCarousel()),

          _sectionTitle("Dễ dàng thiết lập"),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  const Icon(Icons.important_devices_rounded,
                      color: Colors.deepOrange, size: 45),
                  const SizedBox(height: 20),
                  const Text(
                    "Chuyển dữ liệu sang Apple Watch mới bằng iPhone.",
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
                  ),
                ],
              ),
            ),
          ),

          _sectionTitle("Tìm mảnh ghép hoàn hảo\nvới bạn >"),
          SliverToBoxAdapter(child: _accessoriesCarousel(context)),

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
                        _pillButton("Tất Cả Phụ Kiện Cho Apple Watch"),
                        _pillButton("Dây Đeo Apple Watch"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 120),
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
                              shape: BoxShape.circle),
                          child: const Icon(Icons.phone,
                              color: Colors.blueAccent, size: 40),
                        ),
                        const SizedBox(height: 15),
                        const Text("Trò chuyện với\nchúng tôi qua\nđiện thoại",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontSize: 16)),
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
  }

  Widget _infoCard(String image, String title, String subtitle,
      {double bottomMargin = 0}) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(24)),
            child: Image.asset(image, width: 120, height: 120, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 14)),
                ],
              ),
            ),
          ),
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

  // ===== HERO SẢN PHẨM (đọc ProductStore c4, sửa được khi isAdmin) =====
  Widget _heroCarousel(BuildContext context) {
    final watches = context.watch<ProductStore>().byCategory('c4');

    if (watches.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
              isAdmin
                  ? 'Chưa có Apple Watch nào. Bấm + để thêm.'
                  : 'Chưa có Apple Watch nào.',
              style: const TextStyle(color: Colors.white54, fontSize: 16)),
        ),
      );
    }

    const dotColors = [Colors.grey, Colors.white, Colors.black];

    return SizedBox(
      height: 680,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: watches.length,
        itemBuilder: (context, index) {
          final Product watch = watches[index];

          return Container(
            width: 340,
            margin: const EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: isAdmin
                      ? () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => EditProductSheet(
                                product: watch, allProducts: watches),
                          )
                      : null,
                  child: Container(
                    height: 380,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(32),
                      image: DecorationImage(
                        image: productImageProvider(watch.imagePaths.first),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: dotColors
                      .map((c) => Container(
                            margin: const EdgeInsets.only(right: 6),
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white24, width: 1),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 15),
                if (watch.tag.isNotEmpty)
                  Text(watch.tag,
                      style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(watch.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(watch.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 16, height: 1.4)),
                const SizedBox(height: 15),
                Text(
                  'Từ ${NumberFormat("#,###", "vi_VN").format(watch.price)}đ',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 25),
                isAdmin
                    ? _adminButtons(context, watch, watches)
                    : _customerButtons(context, watch),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _customerButtons(BuildContext context, Product watch) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            Provider.of<CartProvider>(context, listen: false).addItem(watch);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${watch.name} đã được thêm vào giỏ hàng.'),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.blueAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text("Mua",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 15),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C1C1E),
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text("Tìm hiểu thêm",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _adminButtons(
      BuildContext context, Product watch, List<Product> watches) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) =>
                EditProductSheet(product: watch, allProducts: watches),
          ),
          icon: const Icon(Icons.edit, size: 18),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
          ),
          label: const Text("Sửa",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                content: Text('Xoá "${watch.name}"?',
                    style: const TextStyle(color: Colors.white70)),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Huỷ')),
                  TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Xoá',
                          style: TextStyle(color: Colors.red))),
                ],
              ),
            );
            if (ok == true && context.mounted) {
              context.read<ProductStore>().deleteProduct(watch.id);
            }
          },
          icon: const Icon(Icons.delete_outline, size: 18),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C1C1E),
            foregroundColor: Colors.redAccent,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
          ),
          label: const Text("Xoá",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
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
              color: const Color(0xFF7A7A7A),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                      image: DecorationImage(
                        image: AssetImage("assets/images/watch_cat.jpg"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Đổi cũ lấy mới chưa bao giờ dễ dàng đến thế.",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.2)),
                      SizedBox(height: 10),
                      Text(
                          "Tiết kiệm cho lần mua Apple Watch tiếp theo khi trao đổi thiết bị đang dùng. Dễ dàng thực hiện trực tuyến hoặc tại cửa hàng.",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              height: 1.4)),
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

  Widget _accessoriesCarousel(BuildContext context) {
    final accessories = [
      {
        "id": "watch-band-clementine",
        "image": "assets/images/watch.jpg",
        "name": "Dây Đeo Thể Thao Màu Cam Clementine 46mm - M/L",
        "price": "1.499.000đ",
        "priceValue": 1499000.0,
      },
      {
        "id": "watch-band-milan-gold",
        "image": "assets/images/watch.jpg",
        "name": "Dây Quấn Milan Màu Gold 46mm - M/L",
        "price": "2.999.000đ",
        "priceValue": 2999000.0,
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
                      Center(
                          child: Image.asset(item["image"] as String,
                              height: 160)),
                      const Positioned(
                          top: 15,
                          right: 15,
                          child: Icon(Icons.bookmark_border,
                              color: Colors.white54)),
                      if (!isAdmin)
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () {
                              final product = Product(
                                id: item["id"] as String,
                                name: item["name"] as String,
                                description: item["name"] as String,
                                price: item["priceValue"] as double,
                                imagePaths: [item["image"] as String],
                                categoryId: "watch-accessory",
                              );
                              Provider.of<CartProvider>(context, listen: false)
                                  .addItem(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${product.name} đã được thêm vào giỏ hàng.'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.blueAccent,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14)),
                                ),
                              );
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.add,
                                  color: Colors.black, size: 20),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(item["name"] as String,
                    maxLines: 2,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 5),
                Text(item["price"] as String,
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
