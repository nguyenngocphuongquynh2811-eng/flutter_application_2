import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../providers/auth_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _showNotificationBanner = true;

  @override
  Widget build(BuildContext context) {
    final email = context.watch<AuthProvider>().currentUser?.email ?? 'Khách';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                      ),
                    ),
                  ),
                  const Text(
                    "Đơn hàng",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                children: [
                  if (_showNotificationBanner) ...[
                    _notificationBanner(),
                    const SizedBox(height: 32),
                  ],

                  const Text(
                    "Đơn Hàng Của Bạn",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  _ordersList(),

                  const SizedBox(height: 40),

                  const Text(
                    "Bạn không thấy tất cả đơn hàng của mình?",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
                      children: [
                        const TextSpan(text: "Bạn hiện đang đăng nhập bằng\n"),
                        TextSpan(
                          text: email,
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Để xem tài khoản khác, hãy vào Trạng Thái Đơn Hàng trên apple.com, chọn Sử dụng Tài khoản Apple khác rồi đăng nhập bằng tài khoản Apple khác của bạn.",
                    style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          color: const Color(0xFF1C1C1E),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Tạo Phím Tắt Siri để kiểm tra trạng thái các đơn hàng gần đây.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Colors.pinkAccent, Colors.blueAccent, Colors.purpleAccent],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Thêm vào Siri",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notificationBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications, color: Colors.redAccent, size: 40),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF2C2C2E), width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bật Thông Báo để nhận thông tin cập nhật khi trạng thái đơn hàng của bạn thay đổi.",
                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600, height: 1.35),
                      ),
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Mở Cài Đặt Hệ Thống",
                          style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => setState(() => _showNotificationBanner = false),
              child: const Icon(Icons.close, color: Colors.white38, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ordersList() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Text(
        'Bạn cần đăng nhập để xem đơn hàng.',
        style: TextStyle(color: Colors.white70, fontSize: 15),
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }
        if (snapshot.hasError) {
          return Text(
            'Không thể tải đơn hàng: ${snapshot.error}',
            style: const TextStyle(color: Colors.redAccent, fontSize: 14),
          );
        }

        final orders = (snapshot.data?.docs ?? const [])
            .map(Order.fromFirestore)
            .toList()
          ..sort((a, b) {
            if (a.createdAt == null || b.createdAt == null) return 0;
            return b.createdAt!.compareTo(a.createdAt!);
          });

        if (orders.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              'Bạn chưa có đơn hàng nào.',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
          );
        }

        return Column(
          children: orders
              .map((order) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _orderCard(order),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _orderCard(Order order) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final createdAt = order.createdAt;
    final dateText =
        createdAt != null ? '${createdAt.day} tháng ${createdAt.month}, ${createdAt.year}' : '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              firstItem != null && firstItem.imagePath.isNotEmpty
                  ? firstItem.imagePath
                  : "assets/images/ipad_pro.jpg",
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (dateText.isNotEmpty)
                  Text(
                    dateText,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                const SizedBox(height: 6),
                Text(
                  order.itemsSummary,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, height: 1.3),
                ),
                const SizedBox(height: 12),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    children: [
                      const TextSpan(text: "Đơn hàng #: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      TextSpan(text: order.id.substring(0, order.id.length.clamp(0, 8)).toUpperCase()),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      "Trạng thái: ",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      order.status,
                      style: TextStyle(color: _statusColor(order.status), fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${NumberFormat("#,###", "vi_VN").format(order.totalAmount)} ₫',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Đã giao':
        return Colors.blueAccent;
      case 'Đang giao':
        return Colors.orangeAccent;
      case 'Đã huỷ':
        return Colors.redAccent;
      default:
        return Colors.white70;
    }
  }
}
