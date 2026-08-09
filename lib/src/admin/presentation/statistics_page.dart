import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/order.dart';

const _statusColors = {
  'Đang xử lý': Colors.white54,
  'Đang giao': Colors.orangeAccent,
  'Đã giao': Colors.blueAccent,
  'Đã huỷ': Colors.redAccent,
};

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Lỗi tải thống kê: ${snapshot.error}',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data!.docs.map(Order.fromFirestore).toList();
        if (orders.isEmpty) {
          return const Center(
            child: Text('Chưa có đơn hàng nào để thống kê.',
                style: TextStyle(color: Colors.white54)),
          );
        }

        final validOrders = orders.where((o) => o.status != 'Đã huỷ').toList();
        final totalRevenue = validOrders.fold<double>(0, (acc, o) => acc + o.totalAmount);
        final totalOrders = orders.length;

        final statusCounts = <String, int>{};
        for (final o in orders) {
          statusCounts[o.status] = (statusCounts[o.status] ?? 0) + 1;
        }

        final productQuantities = <String, int>{};
        for (final o in validOrders) {
          for (final item in o.items) {
            productQuantities[item.name] = (productQuantities[item.name] ?? 0) + item.quantity;
          }
        }
        final topProducts = productQuantities.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final top5 = topProducts.take(5).toList();
        final maxQuantity = top5.isEmpty ? 1 : top5.first.value;

        final currency = NumberFormat("#,###", "vi_VN");

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _StatTile(
                  label: 'Tổng doanh thu',
                  value: '${currency.format(totalRevenue)} ₫',
                  icon: Icons.payments_outlined,
                  color: Colors.blueAccent,
                ),
                _StatTile(
                  label: 'Tổng số đơn',
                  value: '$totalOrders',
                  icon: Icons.receipt_long_outlined,
                  color: Colors.white,
                ),
                _StatTile(
                  label: 'Đang xử lý',
                  value: '${statusCounts['Đang xử lý'] ?? 0}',
                  icon: Icons.hourglass_empty,
                  color: _statusColors['Đang xử lý']!,
                ),
                _StatTile(
                  label: 'Đã huỷ',
                  value: '${statusCounts['Đã huỷ'] ?? 0}',
                  icon: Icons.cancel_outlined,
                  color: _statusColors['Đã huỷ']!,
                ),
              ],
            ),

            const SizedBox(height: 28),
            const Text('Đơn hàng theo trạng thái',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: _statusColors.keys.map((status) {
                  final count = statusCounts[status] ?? 0;
                  final ratio = totalOrders == 0 ? 0.0 : count / totalOrders;
                  final isLast = status == _statusColors.keys.last;
                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                    child: _StatusBar(
                      label: status,
                      count: count,
                      ratio: ratio,
                      color: _statusColors[status]!,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 28),
            const Text('Top sản phẩm bán chạy',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            if (top5.isEmpty)
              const Text('Chưa có dữ liệu.', style: TextStyle(color: Colors.white38))
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: List.generate(top5.length, (i) {
                    final entry = top5[i];
                    final ratio = entry.value / maxQuantity;
                    final isLast = i == top5.length - 1;
                    return Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                      child: _ProductBar(
                        rank: i + 1,
                        name: entry.key,
                        quantity: entry.value,
                        ratio: ratio,
                      ),
                    );
                  }),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 22),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({
    required this.label,
    required this.count,
    required this.ratio,
    required this.color,
  });

  final String label;
  final int count;
  final double ratio;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ),
            Text('$count', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _ProductBar extends StatelessWidget {
  const _ProductBar({
    required this.rank,
    required this.name,
    required this.quantity,
    required this.ratio,
  });

  final int rank;
  final String name;
  final int quantity;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('$rank.', style: const TextStyle(color: Colors.white38, fontSize: 13)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
            Text('$quantity đã bán',
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation(Colors.blueAccent),
          ),
        ),
      ],
    );
  }
}
