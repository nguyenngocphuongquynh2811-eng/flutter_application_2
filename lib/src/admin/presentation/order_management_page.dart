import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/order.dart';

const _statuses = ['Đang xử lý', 'Đang giao', 'Đã giao', 'Đã huỷ'];

class OrderManagementPage extends StatelessWidget {
  const OrderManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi tải danh sách đơn hàng: ${snapshot.error}',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs.map(Order.fromFirestore).toList()
            ..sort((a, b) {
              if (a.createdAt == null || b.createdAt == null) return 0;
              return b.createdAt!.compareTo(a.createdAt!);
            });

          if (orders.isEmpty) {
            return const Center(
              child: Text('Chưa có đơn hàng nào.', style: TextStyle(color: Colors.white54)),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _OrderTile(order: orders[index]),
          );
        },
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});

  final Order order;

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

  Future<void> _updateStatus(BuildContext context, String newStatus) async {
    await FirebaseFirestore.instance.collection('orders').doc(order.id).update({
      'status': newStatus,
    });
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã cập nhật trạng thái: $newStatus'),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final createdAt = order.createdAt;
    final dateText =
        createdAt != null ? '${createdAt.day}/${createdAt.month}/${createdAt.year}' : '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.recipientName.isEmpty ? order.userEmail : order.recipientName,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (dateText.isNotEmpty)
                Text(dateText, style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '#${order.id.substring(0, order.id.length.clamp(0, 8)).toUpperCase()} · ${order.userEmail}',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            order.itemsSummary,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          if (order.shippingAddress.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              order.shippingAddress,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '${NumberFormat("#,###", "vi_VN").format(order.totalAmount)} ₫',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                initialValue: order.status,
                color: const Color(0xFF2C2C2E),
                onSelected: (status) => _updateStatus(context, status),
                itemBuilder: (context) => _statuses
                    .map((s) => PopupMenuItem(
                          value: s,
                          child: Text(s, style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColor(order.status).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _statusColor(order.status).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        order.status,
                        style: TextStyle(
                          color: _statusColor(order.status),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down, color: _statusColor(order.status), size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
