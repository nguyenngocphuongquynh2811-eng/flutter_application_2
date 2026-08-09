import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_2/widgets/product_image.dart';

/// Màn Thống kê — sản phẩm bán chạy nhất trong THÁNG hiện tại, tính từ collection `orders`.
class AdminStatsScreen extends StatelessWidget {
  const AdminStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final ordersRef = FirebaseFirestore.instance.collection('orders');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Thống kê tháng ${now.month}/${now.year}',
            style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ordersRef.snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }
          final docs = snap.data?.docs ?? [];

          final Map<String, _Stat> stats = {};
          int orderCount = 0;
          double revenue = 0;

          for (final d in docs) {
            final data = d.data();
            if ((data['status'] as String?) == 'Đã huỷ') continue;
            final ts = data['createdAt'];
            if (ts is! Timestamp) continue;
            if (ts.toDate().isBefore(startOfMonth)) continue; // chỉ tháng này

            orderCount++;
            revenue += (data['totalAmount'] as num?)?.toDouble() ?? 0;

            for (final raw in (data['items'] as List?) ?? []) {
              final it = raw as Map<String, dynamic>;
              final id = (it['productId'] as String?) ??
                  (it['name'] as String? ?? '?');
              final qty = (it['quantity'] as num?)?.toInt() ?? 0;
              final price = (it['price'] as num?)?.toDouble() ?? 0;
              final s = stats.putIfAbsent(
                id,
                () => _Stat(
                  name: (it['name'] as String?) ?? '',
                  image: (it['imagePath'] as String?) ?? '',
                ),
              );
              s.quantity += qty;
              s.revenue += price * qty;
            }
          }

          final ranked = stats.values.toList()
            ..sort((a, b) => b.quantity.compareTo(a.quantity));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                      child: _summaryCard(
                          'Số đơn', '$orderCount', Icons.receipt_long)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _summaryCard(
                          'Doanh thu',
                          '${NumberFormat("#,###", "vi_VN").format(revenue)}đ',
                          Icons.payments)),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Sản phẩm bán chạy',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (ranked.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text('Chưa có đơn nào trong tháng này.',
                        style: TextStyle(color: Colors.white54)),
                  ),
                )
              else
                ...ranked.asMap().entries.map((e) =>
                    _statRow(e.key + 1, e.value, ranked.first.quantity)),
            ],
          );
        },
      ),
    );
  }

  Widget _summaryCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 26),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _statRow(int rank, _Stat s, int maxQty) {
    final ratio = maxQty == 0 ? 0.0 : s.quantity / maxQty;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text('$rank',
                style: TextStyle(
                    color: rank <= 3 ? Colors.orange : Colors.white54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ProductImage(s.image, width: 48, height: 48),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 6,
                    backgroundColor: Colors.white12,
                    valueColor:
                        const AlwaysStoppedAnimation(Colors.blueAccent),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                    'Đã bán ${s.quantity}  •  ${NumberFormat("#,###", "vi_VN").format(s.revenue)}đ',
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat {
  final String name;
  final String image;
  int quantity = 0;
  double revenue = 0;
  _Stat({required this.name, required this.image});
}
