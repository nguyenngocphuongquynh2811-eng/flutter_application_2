import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/src/product/screen/admin_shop_screen.dart';

import '../../../providers/auth_provider.dart';
import 'order_management_page.dart';
import 'promotion_management_page.dart';
import 'statistics_page.dart';

class _ManagerNavItem {
  const _ManagerNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.screen,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget screen;
}

class ManagerShell extends StatefulWidget {
  const ManagerShell({super.key});

  @override
  State<ManagerShell> createState() => _ManagerShellState();
}

class _ManagerShellState extends State<ManagerShell> {
  int _index = 0;

  static const _items = <_ManagerNavItem>[
    _ManagerNavItem(
      label: 'Sản phẩm',
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2,
      screen: AdminShopScreen(),
    ),
    _ManagerNavItem(
      label: 'Đơn hàng',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      screen: OrderManagementPage(),
    ),
    _ManagerNavItem(
      label: 'Khuyến mãi',
      icon: Icons.local_offer_outlined,
      activeIcon: Icons.local_offer,
      screen: PromotionManagementPage(),
    ),
    _ManagerNavItem(
      label: 'Thống kê',
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart,
      screen: StatisticsPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _items[_index].screen,
      bottomNavigationBar: _ManagerBottomBar(
        items: _items,
        index: _index,
        onSelect: (i) => setState(() => _index = i),
      ),
    );
  }
}

/// Thanh điều hướng nổi, bo tròn — đồng bộ với AdminShell/RootScreen, nhưng
/// chỉ có các tab dành cho Manager (không có Tài khoản / Cài đặt).
class _ManagerBottomBar extends StatelessWidget {
  const _ManagerBottomBar({
    required this.items,
    required this.index,
    required this.onSelect,
  });

  final List<_ManagerNavItem> items;
  final int index;
  final ValueChanged<int> onSelect;

  static const _pillRadius = 36.0;
  static const _pillHeight = 72.0;

  BoxDecoration get _pillDecoration => BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(_pillRadius),
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: _pillHeight,
                decoration: _pillDecoration,
                child: Row(
                  children: List.generate(items.length, (i) {
                    final item = items[i];
                    final selected = i == index;
                    final color = selected ? Colors.blue : Colors.white70;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onSelect(i),
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              selected ? item.activeIcon : item.icon,
                              color: color,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: color,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Container(
              width: _pillHeight,
              height: _pillHeight,
              decoration: _pillDecoration,
              child: IconButton(
                onPressed: () => context.read<AuthProvider>().logout(),
                icon: const Icon(
                  Icons.logout_rounded,
                  size: 26,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
