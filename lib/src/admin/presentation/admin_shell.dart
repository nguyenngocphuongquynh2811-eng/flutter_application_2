import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/src/product/product_page.dart';

import '../../../providers/auth_provider.dart';
import '../../core/theme/admin_theme.dart';

class NavItem {
  const NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.screen,
  });

  final String label;
  final IconData icon;       // icon lúc chưa chọn
  final IconData activeIcon; // icon lúc đang chọn, đậm hơn
  final Widget screen;
}

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  static const _items = <NavItem>[
    NavItem(
      label: 'Sản phẩm',
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2,
      screen: ProductPage(),
    ),
    NavItem(
      label: 'Đơn hàng',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      screen: _Placeholder('Quản lý đơn hàng'),
    ),
    NavItem(
      label: 'Khuyến mãi',
      icon: Icons.local_offer_outlined,
      activeIcon: Icons.local_offer,
      screen: _Placeholder('Quản lý khuyến mãi'),
    ),
    NavItem(
      label: 'Tài khoản',
      icon: Icons.people_outline,
      activeIcon: Icons.people,
      screen: _Placeholder('Quản lý tài khoản'),
    ),
    NavItem(
      label: 'Thống kê',
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart,
      screen: _Placeholder('Thống kê'),
    ),
    NavItem(
      label: 'Cài đặt',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      screen: _Placeholder('Cài đặt'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _TopBar(title: _items[_index].label),
          Expanded(child: _items[_index].screen),
        ],
      ),
      bottomNavigationBar: _ScrollableBottomBar(
        items: _items,
        index: _index,
        onSelect: (i) => setState(() => _index = i),
      ),
    );
  }
}

/// Thanh điều hướng nổi, bo tròn, cuộn ngang — đồng bộ với RootScreen bên khách hàng.
class _ScrollableBottomBar extends StatelessWidget {
  const _ScrollableBottomBar({
    required this.items,
    required this.index,
    required this.onSelect,
  });

  final List<NavItem> items;
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
                // Cắt theo bo góc để nội dung cuộn không tràn ra ngoài viên thuốc.
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_pillRadius),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      final selected = i == index;
                      final color = selected ? Colors.blue : Colors.white70;

                      return GestureDetector(
                        onTap: () => onSelect(i),
                        behavior: HitTestBehavior.opaque,
                        child: SizedBox(
                          width: 76,
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
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Nút tròn tách riêng — giống nút tìm kiếm bên app khách hàng.
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Apple Store',
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Colors.white70),
            ),
            const SizedBox(width: 4),
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF2C2C2E),
              child: Text(
                'TH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text,
          style: const TextStyle(fontSize: 16, color: AdminColors.textDim)),
    );
  }
}
