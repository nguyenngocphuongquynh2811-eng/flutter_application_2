import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../data/product_store.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import 'package:flutter_application_2/widgets/product_image.dart';
import 'package:flutter_application_2/src/product/sheet/add_product_sheet.dart';
import 'package:flutter_application_2/src/product/sheet/edit_product_sheet.dart';
import 'product_detail_screen.dart';
import '../../widgets/persistent_bottom_nav.dart';

/// Trang danh mục DÙNG CHUNG cho khách và admin — cùng bố cục với
/// IphonePage/WatchPage (hero carousel, banner đổi cũ lấy mới, phụ kiện...)
/// để mọi danh mục (Mac, iPad...) đồng bộ giao diện với iPhone/Apple Watch.
class CategoryPage extends StatelessWidget {
  final String categoryId;
  final String title;
  final String heroImage;

  /// categoryId của phụ kiện liên quan (VD: 'accessory-mac'). Để trống thì
  /// ẩn hẳn mục "Tìm mảnh ghép hoàn hảo" vì chưa có dữ liệu phụ kiện thật.
  final String? accessoryCategoryId;
  final bool isAdmin;

  const CategoryPage({
    super.key,
    required this.categoryId,
    required this.title,
    required this.heroImage,
    this.accessoryCategoryId,
    this.isAdmin = false,
  });

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
            backgroundColor: Colors.black,
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
                        builder: (_) => AddProductSheet(categoryId: categoryId),
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
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5)),
            ),
          ),

          SliverToBoxAdapter(child: _heroCarousel(context)),

          // Banner đổi cũ lấy mới
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
                      child: ProductImage(heroImage,
                          width: 120, height: 120, fit: BoxFit.cover),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("So sánh tất cả các\nphiên bản",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text("Xem $title nào phù hợp với bạn.",
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          _sectionTitle("Xem cập nhật mới về $title"),
          SliverToBoxAdapter(child: _featureCarousel()),

          _sectionTitle("Dễ dàng thiết lập"),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                  ),
                ],
              ),
            ),
          ),

          if (accessoryCategoryId != null) ...[
            _sectionTitle("Tìm mảnh ghép hoàn hảo\nvới bạn >"),
            SliverToBoxAdapter(child: _accessoriesCarousel(context)),
          ],

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
      bottomNavigationBar: isAdmin ? null : const PersistentBottomNav(),
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

  // ===== HERO SẢN PHẨM (đọc ProductStore, sửa được khi isAdmin) =====
  Widget _heroCarousel(BuildContext context) {
    final products = context.watch<ProductStore>().byCategory(categoryId);

    if (products.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
              isAdmin ? 'Chưa có $title nào. Bấm + để thêm.' : 'Chưa có $title nào.',
              style: const TextStyle(color: Colors.white54, fontSize: 16)),
        ),
      );
    }

    const dotColors = [Colors.blueGrey, Colors.white, Colors.black];

    return SizedBox(
      height: 640,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final Product product = products[index];

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
                                product: product, allProducts: products),
                          )
                      : null,
                  child: Container(
                    height: 360,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(32),
                      image: DecorationImage(
                        image: productImageProvider(product.imagePaths.first),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
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
                if (product.tag.isNotEmpty)
                  Text(product.tag,
                      style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 15, height: 1.4)),
                const SizedBox(height: 12),
                Text(
                  'Từ ${NumberFormat("#,###", "vi_VN").format(product.price)}đ',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 18),
                isAdmin
                    ? _adminButtons(context, product, products)
                    : _customerButtons(context, product),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _customerButtons(BuildContext context, Product product) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            Provider.of<CartProvider>(context, listen: false).addItem(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} đã được thêm vào giỏ hàng.'),
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: product),
              ),
            );
          },
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
      BuildContext context, Product product, List<Product> products) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) =>
                EditProductSheet(product: product, allProducts: products),
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
                content: Text('Xoá "${product.name}"?',
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
              context.read<ProductStore>().deleteProduct(product.id);
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
                Text("Viết lách, thể hiện bản thân và hoàn thành công việc dễ dàng.",
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
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(28)),
                      image: DecorationImage(
                        image: productImageProvider(heroImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _accessoriesCarousel(BuildContext context) {
    final accessories =
        context.watch<ProductStore>().byCategory(accessoryCategoryId!);

    if (accessories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 380,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: accessories.length,
        itemBuilder: (context, index) {
          final item = accessories[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: item),
              ),
            ),
            child: Container(
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
                    child: Center(
                      child: ProductImage(item.imagePaths.first, height: 160),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  Text(
                      '${NumberFormat("#,###", "vi_VN").format(item.price)}đ',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
