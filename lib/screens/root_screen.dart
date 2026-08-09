import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/root_tab_provider.dart';
import '../widgets/persistent_bottom_nav.dart';
import 'shop/shop_screen.dart';
import 'discover/discover_screen.dart';
import 'for_you/for_you_screen.dart';
import 'search/search_screen.dart';
import 'cart/cart_screen.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  static const _screens = [
    ForYouScreen(),   // 0
    ShopScreen(),     // 1
    DiscoverScreen(), // 2
    CartScreen(),     // 3
    SearchScreen(),   // 4
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<RootTabProvider>().index;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: const PersistentBottomNav(),
    );
  }
}
