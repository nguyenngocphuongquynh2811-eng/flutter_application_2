import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_2/widgets/product_image.dart';

/// Màn admin quản lý đơn hàng — đọc collection `orders` real-time từ Firestore.
class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({super.key});

  static const statuses = <String>[
    'Đang xử lý',
    'Đã xác nhận',
    'Đang giao',
    'Đã giao',
    'Đã huỷ',
  ];

  static Color statusColor(String s) {
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
    final ordersRef = FirebaseFirestore.instance
        .collection('orders')
        .orderBy('createdAt', descending: true);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Quản lý đơn hàng',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ordersRef.snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }
          if (snap.hasError) {
            return Center(
              child: Text('Lỗi tải đơn hàng: ${snap.error}',
                  style: const TextStyle(color: Colors.white70)),
            );
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text('Chưa có đơn hàng nào.',
                  style: TextStyle(color: Colors.white54, fontSize: 16)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) => _OrderCard(doc: docs[i]),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  const _OrderCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    final data = doc.data();
    final items = (data['items'] as List?) ?? [];
    final status = (data['status'] as String?) ?? 'Đang xử lý';
    final total = (data['totalAmount'] as num?)?.toDouble() ?? 0;
    final ts = data['createdAt'];
    final date = ts is Timestamp
        ? DateFormat('dd/MM/yyyy HH:mm').format(ts.toDate())
        : '—';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        data['userName']?.toString().isNotEmpty == true
                            ? data['userName']
                            : (data['userEmail'] ?? 'Khách'),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text(data['userEmail'] ?? '',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AdminOrderScreen.statusColor(status)
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(status,
                    style: TextStyle(
                        color: AdminOrderScreen.statusColor(status),
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Mã đơn: ${doc.id}   •   $date',
              style: const TextStyle(color: Colors.white38, fontSize: 12)),
          const Divider(color: Colors.white12, height: 24),
          ...items.map((raw) {
            final it = raw as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ProductImage(
                      (it['imagePath'] as String?) ?? '',
                      width: 44,
                      height: 44,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(it['name'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14)),
                  ),
                  const SizedBox(width: 8),
                  Text('x${it['quantity'] ?? 1}',
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng cộng',
                  style: TextStyle(color: Colors.white70)),
              Text('${NumberFormat("#,###", "vi_VN").format(total)} ₫',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Trạng thái: ',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  value: AdminOrderScreen.statuses.contains(status)
                      ? status
                      : AdminOrderScreen.statuses.first,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF2C2C2E),
                  style: const TextStyle(color: Colors.white),
                  items: AdminOrderScreen.statuses
                      .map((s) =>
                          DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (newStatus) {
                    if (newStatus == null || newStatus == status) return;
                    doc.reference.update({'status': newStatus});
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}