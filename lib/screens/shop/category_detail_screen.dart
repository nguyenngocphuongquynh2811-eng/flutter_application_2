import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../data/mock_data.dart';
import '../../widgets/product_card.dart';

class CategoryDetailScreen extends StatelessWidget {
  final Category category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Filter products for this specific category
    final categoryProducts = MockData.featuredProducts
        .where((product) => product.categoryId == category.id)
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: categoryProducts.isEmpty
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
                childAspectRatio: 0.6, // Adjusted for taller ProductCard style
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categoryProducts.length,
              itemBuilder: (context, index) {
                // To reuse the ProductCard widget without breaking its width constraint inside a GridView,
                // we'll wrap it or just use it directly since it expands inside GridView.
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ProductCard(product: categoryProducts[index]),
                );
              },
            ),
    );
  }
}
