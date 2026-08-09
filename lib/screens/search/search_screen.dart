import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/product_store.dart';
import '../../models/product.dart';
import '../shop/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  static const _suggestions = [
    'iPhone 15 Pro',
    'Apple Watch Ultra',
    'MacBook Air M3',
    'AirPods Pro',
    'iPad Pro',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String value) {
    setState(() => _query = value);
  }

  @override
  Widget build(BuildContext context) {
    final allProducts = context.watch<ProductStore>().products;
    final query = _query.trim().toLowerCase();
    final results = query.isEmpty
        ? const <Product>[]
        : allProducts.where((p) => p.name.toLowerCase().contains(query)).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Tìm kiếm',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: _search,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Tìm sản phẩm, cửa hàng...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () {
                              _controller.clear();
                              _search('');
                            },
                          ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: query.isEmpty
                    ? _suggestionsView()
                    : _resultsView(results),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _suggestionsView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gợi ý tìm kiếm',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _suggestions.map((s) => _buildSearchTag(s)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _resultsView(List<Product> results) {
    if (results.isEmpty) {
      return const Center(
        child: Text(
          'Không tìm thấy sản phẩm phù hợp.',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = results[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    product.imagePaths.isNotEmpty ? product.imagePaths[0] : 'assets/images/iphone.jpg',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${NumberFormat("#,###", "vi_VN").format(product.price)} ₫',
                        style: const TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white38),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchTag(String text) {
    return GestureDetector(
      onTap: () {
        _controller.text = text;
        _search(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}
