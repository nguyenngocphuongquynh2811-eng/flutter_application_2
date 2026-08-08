import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'orders_screen.dart';
import 'profile_placeholder_screen.dart';
import 'reservation_screen.dart';
import 'shipping_address_screen.dart';

class AccountBottomSheet extends StatefulWidget {
  const AccountBottomSheet({super.key});

  @override
  State<AccountBottomSheet> createState() => _AccountBottomSheetState();
}

class _AccountBottomSheetState extends State<AccountBottomSheet> {
  bool showSmallTitle = false;
  bool _isUploadingAvatar = false;

  Future<void> _pickAvatar() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 70,
    );
    if (picked == null || !mounted) return;

    setState(() => _isUploadingAvatar = true);
    try {
      final bytes = await picked.readAsBytes();
      final base64Image = base64Encode(bytes);
      if (!mounted) return;
      await context.read<AuthProvider>().updateAvatar(base64Image);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể cập nhật ảnh đại diện: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingAvatar = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return DraggableScrollableSheet(
      initialChildSize: 0.90,
      minChildSize: 0.90,
      maxChildSize: 0.90,
      expand: false,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1C1C1E),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(35),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // HEADER CỐ ĐỊNH
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: showSmallTitle ? 1 : 0,
                        child: const Text(
                          "Tài Khoản",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.08),
                              border: Border.all(
                                color: Colors.white10,
                              ),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.pixels > 80 && !showSmallTitle) {
                        setState(() => showSmallTitle = true);
                      } else if (notification.metrics.pixels <= 80 && showSmallTitle) {
                        setState(() => showSmallTitle = false);
                      }
                      return false;
                    },
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: showSmallTitle ? 0 : 1,
                          child: const Text(
                            "Tài Khoản",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C2C2E),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: _isUploadingAvatar ? null : _pickAvatar,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 38,
                                      backgroundImage: user?.avatarBase64 != null
                                          ? MemoryImage(base64Decode(user!.avatarBase64!))
                                          : const AssetImage('assets/images/avatar.jpg')
                                              as ImageProvider,
                                    ),
                                    if (_isUploadingAvatar)
                                      const Positioned.fill(
                                        child: CircleAvatar(
                                          radius: 38,
                                          backgroundColor: Colors.black45,
                                          child: SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(0xFF2C2C2E),
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 18),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user?.name ?? 'Khách',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      user?.email ?? '',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        _section({
                          "Đặt trước": () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ReservationScreen(),
                                ),
                              ),
                          "Đơn hàng": () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const OrdersScreen(),
                                ),
                              ),
                          "Thiết Bị": () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProfilePlaceholderScreen(
                                    title: "Thiết Bị",
                                    heading: "Bật tính năng này\ntrong Cài đặt.",
                                    subtitle:
                                        "Xem thông tin giới thiệu chi tiết về các thiết bị mà bạn sở hữu và nhận các đề xuất dành riêng cho bạn.",
                                    linkText: "Bật Thiết Bị và Dịch Vụ",
                                  ),
                                ),
                              ),
                          "Dịch Vụ": () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProfilePlaceholderScreen(
                                    title: "Dịch Vụ",
                                    heading: "Bật tính năng này\ntrong Cài đặt.",
                                    subtitle:
                                        "Xem thông tin giới thiệu chi tiết về các gói đăng ký dịch vụ của bạn và nhận đề xuất dành riêng cho bạn.",
                                    linkText: "Bật Thiết Bị và Dịch Vụ",
                                  ),
                                ),
                              ),
                          "Mục Đã Lưu": () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProfilePlaceholderScreen(
                                    title: "Mục Đã Lưu",
                                    icon: Icon(Icons.bookmark_border, color: Colors.white54, size: 48),
                                    heading: "Lập danh sách. Yêu\ncầu Chuyên Gia xem qua.",
                                    subtitle:
                                        "Danh sách cho phép Chuyên Gia dễ dàng xem xét và trao đổi về các lựa chọn của bạn — trực tuyến và tại cửa hàng. Mọi ghi chú đều được lưu, vì vậy bạn có thể tiếp tục từ nơi đã dừng bất cứ lúc nào. Lưu sản phẩm đầu tiên của bạn để bắt đầu.",
                                    linkText: "Mua phụ kiện và nhiều sản phẩm khác",
                                  ),
                                ),
                              ),
                        }),

                        const SizedBox(height: 24),

                        _section({
                          "Thanh Toán Chính": null,
                          "Vận Chuyển Chính": () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ShippingAddressScreen(),
                                  fullscreenDialog: true,
                                ),
                              ),
                          "Gửi Phản Hồi": null,
                          "Cài Đặt": null,
                        }),

                        const SizedBox(height: 24),

                        _singleItem("Nhận Trợ Giúp"),

                        const SizedBox(height: 24),

                        GestureDetector(
                          onTap: () async {
                            await context.read<AuthProvider>().logout();
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C2C2E),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Đăng Xuất",
                                    style: TextStyle(color: Colors.redAccent, fontSize: 18),
                                  ),
                                ),
                                Icon(Icons.logout, color: Colors.redAccent, size: 18),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: () => _confirmDeleteAccount(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Xóa Tài Khoản",
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Icon(Icons.delete_forever_outlined, color: Colors.redAccent, size: 20),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        const Text(
                          "Chính Sách Bán Hàng và Hoàn Tiền của Apple",
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          "Câu Hỏi Thường Gặp (FAQ)",
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          "Xác Nhận",
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          "Chính Sách Quyền Riêng Tư của Apple",
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          "Xem cách quản lý dữ liệu của bạn...",
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        ),

                        const SizedBox(height: 40),

                        const Text(
                          "Copyright © 2026 Apple Inc. Mọi quyền được bảo lưu.",
                          style: TextStyle(color: Colors.white38, fontSize: 13),
                        ),

                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('Xóa tài khoản?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Tài khoản sẽ bị xóa vĩnh viễn khỏi hệ thống. Bạn không thể hoàn tác hành động này.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final error = await context.read<AuthProvider>().deleteAccount();
    if (!context.mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
      );
      return;
    }

    Navigator.pop(context);
  }

  Widget _singleItem(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 18),
        ],
      ),
    );
  }

  Widget _section(Map<String, VoidCallback?> items) {
    final entries = items.entries.toList();
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: List.generate(
          entries.length,
          (index) => Column(
            children: [
              ListTile(
                onTap: entries[index].value,
                title: Text(
                  entries[index].key,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 18),
              ),
              if (index != entries.length - 1)
                const Divider(color: Colors.white10, height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
