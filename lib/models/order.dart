import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String imagePath;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imagePath,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      imagePath: map['imagePath'] as String? ?? '',
    );
  }
}

class Order {
  final String id;
  final String userId;
  final String userEmail;
  final String recipientName;
  final String recipientPhone;
  final String shippingAddress;
  final List<OrderItem> items;
  final double subtotal;
  final double shippingFee;
  final double totalAmount;
  final String status;
  final DateTime? createdAt;

  const Order({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.recipientName,
    required this.recipientPhone,
    required this.shippingAddress,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    return Order(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      // Older orders (written before the checkout redesign) used 'userName'
      // instead of 'recipientName' and had no shipping/subtotal fields.
      userEmail: data['userEmail'] as String? ?? '',
      recipientName:
          data['recipientName'] as String? ?? data['userName'] as String? ?? '',
      recipientPhone: data['recipientPhone'] as String? ?? '',
      shippingAddress: data['shippingAddress'] as String? ?? '',
      items: (data['items'] as List<dynamic>? ?? const [])
          .map((e) => OrderItem.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      subtotal: (data['subtotal'] as num?)?.toDouble() ??
          (data['totalAmount'] as num?)?.toDouble() ??
          0,
      shippingFee: (data['shippingFee'] as num?)?.toDouble() ?? 0,
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0,
      status: data['status'] as String? ?? 'Đang xử lý',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  String get itemsSummary {
    if (items.isEmpty) return '';
    final first = items.first.name;
    if (items.length == 1) return first;
    return '$first + ${items.length - 1} sản phẩm khác';
  }
}
