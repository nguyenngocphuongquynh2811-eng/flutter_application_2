import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/widgets/product_image.dart';
import '../../../screens/profile/account_bottom_sheet.dart';
import '../../../widgets/profile_avatar.dart';
import '../../../data/mock_data.dart';
import '../../../models/category.dart';
import '../../../data/shop_card_store.dart';
import '../../../data/experience_card_store.dart';
import 'admin_category_screen.dart';
import '../../../screens/shop/category_page.dart';
import 'admin_iphone_screen.dart';
import 'admin_watch_screen.dart';
import '../widgets/banner_widget.dart';
import '../sheet/edit_shop_card_sheet.dart';
import '../sheet/experience_card_sheet.dart';

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
              titlePadding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sản Phẩm",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
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

          SliverToBoxAdapter(child: _productCategories(context)),

          const SliverToBoxAdapter(child: BannerWidget()),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(22, 30, 22, 15),
              child: Text("Phụ kiện",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
          ),

          SliverToBoxAdapter(child: _accessories()),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 35, 22, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Khám phá sản phẩm mới",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  PopupMenuButton<String>(
                    color: const Color(0xFF2C2C2E),
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onSelected: (value) {
                      final store = context.read<ShopCardStore>();
                      switch (value) {
                        case "add":
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => const EditShopCardSheet(),
                          );
                          break;
                        case "manage":
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => EditShopCardSheet(
                              bigCards: store.bigCards,
                              smallCards: store.smallCards,
                              selectedIndex: 0,
                              isBig: true,
                            ),
                          );
                          break;
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: "add",
                        child: Row(children: [
                          Icon(Icons.add),
                          SizedBox(width: 10),
                          Text("Thêm sản phẩm"),
                        ]),
                      ),
                      PopupMenuItem(
                        value: "manage",
                        child: Row(children: [
                          Icon(Icons.photo_library),
                          SizedBox(width: 10),
                          Text("Quản lý"),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: _newProductsSection(context)),

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
                        color: Colors.white70, fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: const Text("Bật Thiết Bị và Dịch Vụ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          _sectionTitle("Tận hưởng trải nghiệm đến từ Apple"),

          SliverToBoxAdapter(child: _experienceCards(context)),

          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 35, 22, 20),
        child: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  static Widget _productCategories(BuildContext context) {
    final items = [
      ("iphone.jpg", "iPhone", "c2"),
      ("watch.jpg", "Apple Watch", "c4"),
      ("ipad.jpg", "iPad", "c3"),
      ("mac.jpg", "Mac", "c1"),
      ("airpods.jpg", "AirPods", "c5"),
      ("iphone.jpg", "MagSafe", "accessory-magsafe"),
      ("watch.jpg", "Dây Đeo Watch", "accessory-watchband"),
      ("keyboard.jpg", "Phụ Kiện Mac", "accessory-mac"),
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
              if (items[index].$3 == 'c2') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AdminIphoneScreen()));
              } else if (items[index].$3 == 'c4') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AdminWatchScreen()));
              } else if (items[index].$3 == 'c1') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CategoryPage(
                      categoryId: 'c1',
                      title: 'Mac',
                      heroImage: 'assets/images/mac.jpg',
                      accessoryCategoryId: 'accessory-mac',
                      isAdmin: true,
                    ),
                  ),
                );
              } else if (items[index].$3 == 'c3') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CategoryPage(
                      categoryId: 'c3',
                      title: 'iPad',
                      heroImage: 'assets/images/ipad.jpg',
                      isAdmin: true,
                    ),
                  ),
                );
              } else {
                final categoryId = items[index].$3;
                final cat = categoryId.startsWith('accessory-')
                    ? Category(
                        id: categoryId,
                        name: items[index].$2,
                        imagePath: "assets/images/${items[index].$1}",
                      )
                    : MockData.categories
                        .firstWhere((e) => e.id == categoryId);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AdminCategoryScreen(category: cat)));
              }
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
                  Image.asset("assets/images/${items[index].$1}", height: 45),
                  const SizedBox(height: 10),
                  Text(items[index].$2,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _accessories() {
    final accessories = ["Tất Cả Phụ Kiện", "MagSafe", "Dây Đeo Watch"];

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
              child: Text(accessories[index],
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
          );
        },
      ),
    );
  }

  static Widget _experienceCards(BuildContext context) {
    final cards = context.watch<ExperienceCardStore>().cards;

    Future<void> confirmDelete(int index, String title) async {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E),
          title: const Text('Xoá thẻ?', style: TextStyle(color: Colors.white)),
          content: Text('Xoá "$title"?',
              style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Huỷ')),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xoá', style: TextStyle(color: Colors.red))),
          ],
        ),
      );
      if (ok == true && context.mounted) {
        context.read<ExperienceCardStore>().deleteCard(index);
      }
    }

    return SizedBox(
      height: 500,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: cards.length + 1,
        itemBuilder: (_, index) {
          if (index == cards.length) {
            return GestureDetector(
              onTap: () => openExperienceCardSheet(context),
              child: Container(
                width: 200,
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 36),
                    SizedBox(height: 8),
                    Text('Thêm thẻ', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            );
          }

          final item = cards[index];
          return GestureDetector(
            onTap: () =>
                openExperienceCardSheet(context, index: index, card: item),
            onLongPress: () => confirmDelete(index, item.title),
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
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            color: Colors.white,
                            child:
                                ProductImage(item.image, fit: BoxFit.cover),
                          ),
                        ),
                        const Positioned(
                          top: 12,
                          right: 12,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.black54,
                            child: Icon(Icons.edit,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ],
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
                            Text(item.overline!,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: item.textColor
                                        .withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                          ],
                          Text(item.title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: item.textColor,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                  letterSpacing: -0.3)),
                          const SizedBox(height: 10),
                          Text(item.subtitle,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: item.textColor
                                      .withValues(alpha: 0.6),
                                  height: 1.4)),
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
    final store = context.watch<ShopCardStore>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          ...store.bigCards.asMap().entries.map((entry) {
            final index = entry.key;
            final product = entry.value;
            void openEdit() => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => EditShopCardSheet(
                    bigCards: store.bigCards,
                    smallCards: store.smallCards,
                    selectedIndex: index,
                    isBig: true,
                  ),
                );
            return GestureDetector(
              onTap: openEdit,
              child: Padding(
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
                        child: ProductImage(product.image, fit: BoxFit.cover),
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
                                Text(product.tag!,
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              Text(product.title,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(product.subtitle,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 18),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(product.price,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600)),
                                        if (product.priceNote != null)
                                          Text(product.priceNote!,
                                              style: const TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: openEdit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                    ),
                                    child: const Text("Chỉnh sửa"),
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
              ),
            );
          }),
          const SizedBox(height: 10),
          SizedBox(
            height: 450,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: store.smallCards.length,
              itemBuilder: (context, index) {
                final product = store.smallCards[index];
                void openEdit() => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => EditShopCardSheet(
                        bigCards: store.bigCards,
                        smallCards: store.smallCards,
                        selectedIndex: index,
                        isBig: false,
                      ),
                    );
                return GestureDetector(
                  onTap: openEdit,
                  child: Container(
                    width: 330,
                    margin: const EdgeInsets.only(right: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                          color: const Color(0xFFE5E5EA), width: 1),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: ProductImage(product.image,
                                fit: BoxFit.contain),
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
                                  Text(product.tag!,
                                      style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(product.title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text(product.subtitle,
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14)),
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.white
                                            .withValues(alpha: 0.15),
                                        width: 1),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(product.price,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            const SizedBox(height: 2),
                                            if (product.priceNote != null)
                                              Text(product.priceNote!,
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  style: const TextStyle(
                                                      color: Colors.white60,
                                                      fontSize: 11,
                                                      height: 1.2)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: openEdit,
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(70, 40),
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(22)),
                                        ),
                                        child: const Text("Chỉnh sửa",
                                            style: TextStyle(
                                                fontWeight:
                                                    FontWeight.w600)),
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
                Text(item.$2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {},
                  child: const Text("Tìm hiểu thêm >",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}