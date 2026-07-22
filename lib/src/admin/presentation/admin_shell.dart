import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      screen: _Placeholder('Quản lý sản phẩm'),
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
      label: 'Cài đặt',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      screen: _Placeholder('Cài đặt'),
    ),
    NavItem(
      label: 'Profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      screen: _Placeholder('Profile'),
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

/// Thanh điều hướng dưới đáy, cuộn ngang được khi nhiều mục.
class _ScrollableBottomBar extends StatelessWidget {
  const _ScrollableBottomBar({
    required this.items,
    required this.index,
    required this.onSelect,
  });

  final List<NavItem> items;
  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AdminColors.surface,
        border: Border(top: BorderSide(color: AdminColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (context, i) {
              final item = items[i];
              final selected = i == index;

              return Material(
                color: selected
                    ? AdminColors.accent.withValues(alpha: 0.18)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onSelect(i),
                  child: Container(
                    width: 78,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          selected ? item.activeIcon : item.icon,
                          size: 22,
                          color: selected
                              ? AdminColors.accent
                              : AdminColors.textDim,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: selected
                                ? AdminColors.accent
                                : AdminColors.textDim,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
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
    return Container(
      decoration: const BoxDecoration(
        color: AdminColors.background,
        border: Border(bottom: BorderSide(color: AdminColors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Apple Store',
                      style: TextStyle(
                        fontSize: 12,
                        color: AdminColors.textDim,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none,
                    color: AdminColors.textDim),
              ),
              const SizedBox(width: 4),
              PopupMenuButton<String>(
                offset: const Offset(0, 44),
                onSelected: (value) {
                  if (value == 'logout') context.read<AuthProvider>().logout();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 18, color: Colors.redAccent),
                        SizedBox(width: 10),
                        Text('Đăng xuất'),
                      ],
                    ),
                  ),
                ],
                child: const CircleAvatar(
                  radius: 17,
                  backgroundColor: AdminColors.accent,
                  child: Text('AD',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
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