import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../data/product_store.dart';
import '../../../../models/product.dart';
import '../../../src/product/admin_product_view_page.dart'; // Trang xem trước của Admin

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // LẤY TRỰC TIẾP DỮ LIỆU TỪ MOCK DATA Y HỆT BÊN KHÁCH HÀNG
    final featuredProducts = context.watch<ProductStore>().products;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            'Mới nhất.',
            style: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold, 
              color: Colors.white,
            ),
          ),
        ),
        
        // Chiều cao 350 giống hệt với _buildFeaturedProductsList() bên ShopScreen
        SizedBox(
          height: 350, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15), // Giống padding bên ShopScreen
            itemCount: featuredProducts.length,
            itemBuilder: (context, index) {
              final product = featuredProducts[index];
              return _buildAdminProductCard(context, product, featuredProducts);
            },
          ),
        ),
      ],
    );
  }

  // Giao diện thẻ sản phẩm riêng cho Admin để điều hướng đúng luồng
  Widget _buildAdminProductCard(BuildContext context, Product product, List<Product> allProducts) {
    return GestureDetector(
      onTap: () {
        // Nhấn vào sẽ mở trang Xem Chi Tiết dành riêng cho Admin (Có nút Chỉnh sửa)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminProductViewPage(
              product: product,
              allProducts: allProducts,
            ),
          ),
        );
      },
      child: Container(
        width: 220, // Độ rộng thẻ tương đối
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh sản phẩm
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  product.imagePaths.isNotEmpty ? product.imagePaths[0] : 'assets/placeholder.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            
            // Thông tin sản phẩm
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (product.tag.isNotEmpty)
                      Text(
                        product.tag,
                        style: const TextStyle(
                          color: Colors.orange, 
                          fontSize: 12, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      product.name,
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      '${NumberFormat("#,###", "vi_VN").format(product.price)} ₫',
                      style: const TextStyle(
                        color: Colors.grey, 
                        fontSize: 14
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