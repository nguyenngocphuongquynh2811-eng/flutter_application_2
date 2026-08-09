import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/root_tab_provider.dart';

/// Thanh điều hướng nổi dùng chung — y hệt bottomNavigationBar của
/// RootScreen, nhưng dùng được ở cả những trang được đẩy bằng Navigator.push
/// (VD: xem danh mục iPhone/Mac...). Bấm vào sẽ đổi tab trong
/// [RootTabProvider] rồi quay về RootScreen (root route) nếu đang ở trang con.
class PersistentBottomNav extends StatelessWidget {
  const PersistentBottomNav({super.key});

  void _go(BuildContext context, int index) {
    context.read<RootTabProvider>().setTab(index);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  BoxDecoration _pillDecoration() => BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<RootTabProvider>().index;
    final cartCount = context.watch<CartProvider>().itemCount;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 72,
                decoration: _pillDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _navItem(
                      context,
                      icon: Icons.home_rounded,
                      label: 'Dành cho bạn',
                      index: 0,
                      currentIndex: currentIndex,
                    ),
                    _navItem(
                      context,
                      icon: Icons.devices_rounded,
                      label: 'Sản phẩm',
                      index: 1,
                      currentIndex: currentIndex,
                    ),
                    _navItem(
                      context,
                      icon: Icons.explore_rounded,
                      label: 'Xem thêm',
                      index: 2,
                      currentIndex: currentIndex,
                    ),
                    _cartItem(context, cartCount, currentIndex),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 72,
              height: 72,
              decoration: _pillDecoration(),
              child: IconButton(
                onPressed: () => _go(context, 4),
                icon: Icon(
                  Icons.search_rounded,
                  size: 30,
                  color: currentIndex == 4 ? Colors.blue : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
  }) {
    final selected = currentIndex == index;
    return GestureDetector(
      onTap: () => _go(context, index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: selected ? Colors.blue : Colors.white70),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.blue : Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartItem(BuildContext context, int cartCount, int currentIndex) {
    final selected = currentIndex == 3;
    return GestureDetector(
      onTap: () => _go(context, 3),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: selected ? Colors.blue : Colors.white70,
              ),
              const SizedBox(height: 4),
              Text(
                'Giỏ hàng',
                style: TextStyle(
                  color: selected ? Colors.blue : Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (cartCount > 0)
            Positioned(
              right: -10,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  cartCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
