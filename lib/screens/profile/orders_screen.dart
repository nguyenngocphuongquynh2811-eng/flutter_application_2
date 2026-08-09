import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'package:flutter_application_2/widgets/product_image.dart';

/// Màn "Đơn hàng" của khách — đọc đơn THẬT của chính họ từ Firestore.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static Color _statusColor(String s) {
    switch (s) {
      case 'Đã giao':
        return Colors.green;
      case 'Đang giao':
        return Colors.blueAccent;
      case 'Đã xác nhận':
        return Colors.orange;
      case 'Đã huỷ':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = context.watch<AuthProvider>().currentUser?.email ?? 'Khách';
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final query = FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: uid);

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
                        child: const Icon(Icons.chevron_left,
                            color: Colors.white, size: 28),
                      ),
                    ),
                  ),
                  const Text("Đơn hàng",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: query.snapshots(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child:
                            CircularProgressIndicator(color: Colors.white));
                  }
                  final docs = snap.data?.docs ?? [];
                  docs.sort((a, b) {
                    final ta = a.data()['createdAt'];
                    final tb = b.data()['createdAt'];
                    if (ta is Timestamp && tb is Timestamp) {
                      return tb.compareTo(ta);
                    }
                    return 0;
                  });

                  if (docs.isEmpty) {
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                      children: [
                        const Icon(Icons.receipt_long,
                            color: Colors.white24, size: 60),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text('Bạn chưa có đơn hàng nào.',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16)),
                        ),
                        const SizedBox(height: 24),
                        Text.rich(
                          TextSpan(
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                height: 1.5),
                            children: [
                              const TextSpan(text: "Đang đăng nhập bằng\n"),
                              TextSpan(
                                  text: email,
                                  style: const TextStyle(
                                      color: Colors.blueAccent)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                    itemCount: docs.length,
                    itemBuilder: (context, i) =>
                        _orderCard(docs[i].id, docs[i].data()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderCard(String id, Map<String, dynamic> data) {
    final items = (data['items'] as List?) ?? [];
    final status = (data['status'] as String?) ?? 'Đang xử lý';
    final total = (data['totalAmount'] as num?)?.toDouble() ?? 0;
    final ts = data['createdAt'];
    final date = ts is Timestamp
        ? DateFormat('dd/MM/yyyy').format(ts.toDate())
        : '—';

    final firstImage =
        items.isNotEmpty ? (items.first['imagePath'] as String? ?? '') : '';
    final firstName = items.isNotEmpty ? (items.first['name'] ?? '') : '';
    final more = items.length > 1 ? ' + ${items.length - 1} sản phẩm khác' : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
            child: ProductImage(firstImage, width: 80, height: 80),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Text('$firstName$more',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.3)),
                const SizedBox(height: 8),
                Text('Mã đơn: $id',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor(status).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(status,
                          style: TextStyle(
                              color: _statusColor(status),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                    Text('${NumberFormat("#,###", "vi_VN").format(total)} ₫',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}