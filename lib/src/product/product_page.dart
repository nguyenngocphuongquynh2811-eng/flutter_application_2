import 'package:flutter/material.dart';
import 'widgets/banner_widget.dart';
import 'widgets/product_list_widget.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BannerWidget(),
              const SizedBox(height: 10),
              
              // Gọi trực tiếp Widget, nó sẽ tự lôi MockData.featuredProducts ra
              const ProductListWidget(), 
              
              const SizedBox(height: 100), // Khoảng trống cho thanh Nav nổi bên dưới
            ],
          ),
        ),
      ),
    );
  }
}