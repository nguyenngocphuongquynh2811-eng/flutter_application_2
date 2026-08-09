import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/product_store.dart';
import '../../widgets/product_card.dart';

class AccessoryListScreen extends StatelessWidget {
  final String title;
  final List<String> categoryIds;

  const AccessoryListScreen({
    super.key,
    required this.title,
    required this.categoryIds,
  });

  @override
  Widget build(BuildContext context) {
    final products = context
        .watch<ProductStore>()
        .products
        .where((p) => categoryIds.contains(p.categoryId))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: products.isEmpty
          ? const Center(
              child: Text(
                'Chưa có sản phẩm nào.',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ProductCard(product: products[index]),
                );
              },
            ),
    );
  }
}
