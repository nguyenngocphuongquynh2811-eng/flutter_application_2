import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../data/product_store.dart';
import '../product/sheet/add_product_sheet.dart';
import 'admin_product_view_page.dart';
import 'widgets/banner_widget.dart';
class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ProductStore>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: BannerWidget(),
          ),

          SliverToBoxAdapter(
            child: _categoryChips(),
          ),

          for (final cat in MockData.categories)
            ..._categorySection(
              context,
              cat,
              store,
            ),

          const SliverPadding(
            padding: EdgeInsets.only(
              bottom: 120,
            ),
          ),
        ],
      ),
    );
  }
    Widget _categoryChips() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: MockData.categories.length,
        itemBuilder: (_, index) {
          final category =
              MockData.categories[index];

          return Container(
            width: 110,
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Image.asset(
                  category.imagePath,
                  height: 50,
                ),

                const SizedBox(height: 15),

                Text(
                  category.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
    List<Widget> _categorySection(
    BuildContext context,
    dynamic cat,
    ProductStore store,
  ) {
    final items = store.byCategory(cat.id);

    if (items.isEmpty) {
      return const [];
    }

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            22,
            35,
            22,
            20,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cat.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.orange,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => AddProductSheet(
                      categoryId: cat.id,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      SliverToBoxAdapter(
        child: SizedBox(
          height: 350,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            itemCount: items.length,
            itemBuilder: (_, index) {
              return _productCard(
                context,
                items[index],
                items,
              );
            },
          ),
        ),
      ),
    ];
  }
    Widget _productCard(
    BuildContext context,
    dynamic product,
    List allProducts,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdminProductViewPage(
              product: product,
              allProducts: List.from(allProducts),
            ),
          ),
        );
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  product.imagePaths.first,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    if (product.tag.isNotEmpty)
                      Text(
                        product.tag,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                    const SizedBox(height: 8),

                    Text(
                      product.name,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      "${NumberFormat("#,###", "vi_VN").format(product.price)} ₫",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
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
  }
}
