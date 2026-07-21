import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../core/theme/admin_theme.dart';

/// Mô tả một mục trong sidebar.
class NavItem {
  const NavItem({
    required this.label,
    required this.icon,
    required this.screen,
    this.group,
  });

  final String label;
  final IconData icon;
  final Widget screen;

  /// Tiêu đề nhóm hiện phía trên mục này. Null thì không hiện.
  final String? group;
}

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  // Tạm dùng màn hình rỗng, thay dần bằng màn thật ở các bước sau.
  static const _items = <NavItem>[
    NavItem(
      label: 'Sản phẩm',
      icon: Icons.inventory_2_outlined,
      screen: _Placeholder('Quản lý sản phẩm'),
      group: 'Bán hàng',
    ),
    NavItem(
      label: 'Đơn hàng',
      icon: Icons.receipt_long_outlined,
      screen: _Placeholder('Quản lý đơn hàng'),
    ),
    NavItem(
      label: 'Khuyến mãi',
      icon: Icons.local_offer_outlined,
      screen: _Placeholder('Quản lý khuyến mãi'),
      group: 'Marketing',
    ),
    NavItem(
      label: 'Tài khoản',
      icon: Icons.people_outline,
      screen: _Placeholder('Quản lý tài khoản'),
      group: 'Hệ thống',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 1000;

    final content = Column(
      children: [
        _TopBar(title: _items[_index].label, showMenuButton: !isWide),
        Expanded(child: _items[_index].screen),
      ],
    );

    return Scaffold(
      drawer: isWide
          ? null
          : Drawer(
              backgroundColor: const Color.fromARGB(255, 38, 41, 56),
              child: _Sidebar(
                items: _items,
                index: _index,
                onSelect: (i) {
                  setState(() => _index = i);
                  Navigator.pop(context); // đóng drawer sau khi chọn
                },
              ),
            ),
      body: isWide
          ? Row(
              children: [
                Container(
                  width: 250,
                  color: const Color.fromARGB(255, 38, 41, 56),
                  child: _Sidebar(
                    items: _items,
                    index: _index,
                    onSelect: (i) => setState(() => _index = i),
                  ),
                ),
                Expanded(child: content),
              ],
            )
          : content,
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.items,
    required this.index,
    required this.onSelect,
  });

  final List<NavItem> items;
  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 22, 20, 10),
            child: Row(
              children: [
                SizedBox(width: 10),
                Text(
                  'ADMIN ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                final item = items[i];
                final selected = i == index;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (item.group != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
                        child: Text(
                          item.group!.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF6B77A8),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      child: Material(
                        color: selected
                            ? AdminColors.sidebarActive
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => onSelect(i),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 11),
                            child: Row(
                              children: [
                                Icon(
                                  item.icon,
                                  size: 19,
                                  color: selected
                                      ? Colors.white
                                      : AdminColors.sidebarText,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: selected
                                        ? Colors.white
                                        : AdminColors.sidebarText,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          ListTile(
            leading: const Icon(Icons.logout,
                color: AdminColors.sidebarText, size: 20),
            title: const Text('Đăng xuất',
                style: TextStyle(color: AdminColors.sidebarText, fontSize: 14)),
            onTap: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.showMenuButton});

  final String title;
  final bool showMenuButton;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AdminColors.border)),
          ),
          child: Row(
            children: [
              if (showMenuButton)
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const Spacer(),
              const CircleAvatar(
                radius: 16,
                backgroundColor: AdminColors.sidebarActive,
                child: Text('TH',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              const SizedBox(width: 10),
              const Text('Tường', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

/// Màn hình tạm, sẽ thay bằng màn thật.
class _Placeholder extends StatelessWidget {
  const _Placeholder(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text,
          style: const TextStyle(fontSize: 18, color: Colors.black45)),
    );
  }
}