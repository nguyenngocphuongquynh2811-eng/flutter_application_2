import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/auth_text_field.dart';
import '../../widgets/product_image.dart';

const double _freeShippingThreshold = 5000000;
const double _shippingFee = 30000;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = true;
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final authUser = context.read<AuthProvider>().currentUser;
    _nameController.text = authUser?.name ?? '';

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final saved = doc.data()?['shippingAddress'] as Map<String, dynamic>?;
      if (saved != null) {
        final firstName = saved['firstName'] as String? ?? '';
        final lastName = saved['lastName'] as String? ?? '';
        final fullName = [lastName, firstName].where((s) => s.isNotEmpty).join(' ');
        if (fullName.isNotEmpty) _nameController.text = fullName;

        _phoneController.text = saved['phone'] as String? ?? '';

        final addressParts = [
          saved['address'] as String? ?? '',
          saved['ward'] as String? ?? '',
          saved['district'] as String? ?? '',
          saved['province'] as String? ?? '',
        ].where((s) => s.isNotEmpty);
        _addressController.text = addressParts.join(', ');
      }
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _placeOrder(CartProvider cart) async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isPlacingOrder = true);

    final user = context.read<AuthProvider>().currentUser;
    final subtotal = cart.totalAmount;
    final shippingFee = subtotal >= _freeShippingThreshold ? 0.0 : _shippingFee;

    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': uid,
        'userEmail': user?.email ?? '',
        'recipientName': _nameController.text.trim(),
        'recipientPhone': _phoneController.text.trim(),
        'shippingAddress': _addressController.text.trim(),
        'items': cart.items.values
            .map((cartItem) => {
                  'productId': cartItem.product.id,
                  'name': cartItem.product.name,
                  'price': cartItem.product.price,
                  'quantity': cartItem.quantity,
                  'imagePath': cartItem.product.imagePaths.isNotEmpty
                      ? cartItem.product.imagePaths[0]
                      : '',
                })
            .toList(),
        'subtotal': subtotal,
        'shippingFee': shippingFee,
        'totalAmount': subtotal + shippingFee,
        'status': 'Đang xử lý',
        'createdAt': FieldValue.serverTimestamp(),
      });

      cart.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đặt hàng thành công!'),
          backgroundColor: Colors.blueAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đặt hàng thất bại: $e'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final subtotal = cart.totalAmount;
    final shippingFee = subtotal >= _freeShippingThreshold ? 0.0 : _shippingFee;
    final total = subtotal + shippingFee;
    final currency = NumberFormat("#,###", "vi_VN");

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
                    "Thanh toán",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : Form(
                      key: _formKey,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                        children: [
                          _sectionLabel("Thông tin giao hàng"),
                          const SizedBox(height: 14),
                          AuthTextField(
                            controller: _nameController,
                            hint: 'Họ và tên',
                            icon: Icons.person_outline,
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Vui lòng nhập họ tên' : null,
                          ),
                          const SizedBox(height: 14),
                          AuthTextField(
                            controller: _phoneController,
                            hint: 'Số điện thoại',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Vui lòng nhập số điện thoại' : null,
                          ),
                          const SizedBox(height: 14),
                          AuthTextField(
                            controller: _addressController,
                            hint: 'Địa chỉ nhận hàng',
                            icon: Icons.location_on_outlined,
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Vui lòng nhập địa chỉ' : null,
                          ),

                          const SizedBox(height: 28),

                          _sectionLabel("Sản phẩm (${cart.itemCount})"),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1C1E),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: cart.items.values.map((cartItem) {
                                final isLast = cartItem == cart.items.values.last;
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: isLast
                                      ? null
                                      : const BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.white10)),
                                        ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ProductImage(
                                          cartItem.product.imagePaths.isNotEmpty
                                              ? cartItem.product.imagePaths[0]
                                              : 'assets/images/iphone.jpg',
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cartItem.product.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'x${cartItem.quantity}',
                                              style: const TextStyle(color: Colors.white54, fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${currency.format(cartItem.product.price * cartItem.quantity)} ₫',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 28),

                          _sectionLabel("Chi tiết thanh toán"),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1C1E),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                _summaryRow('Tạm tính', '${currency.format(subtotal)} ₫'),
                                const SizedBox(height: 10),
                                _summaryRow(
                                  'Phí vận chuyển',
                                  shippingFee == 0 ? 'Miễn phí' : '${currency.format(shippingFee)} ₫',
                                  valueColor: shippingFee == 0 ? Colors.blueAccent : Colors.white,
                                ),
                                const SizedBox(height: 14),
                                const Divider(color: Colors.white10, height: 1),
                                const SizedBox(height: 14),
                                _summaryRow(
                                  'Tổng cộng',
                                  '${currency.format(total)} ₫',
                                  isTotal: true,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isLoading
          ? null
          : SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(20),
                color: const Color(0xFF1C1C1E),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _isPlacingOrder ? null : () => _placeOrder(cart),
                    child: _isPlacingOrder
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            'Đặt hàng · ${currency.format(total)} ₫',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.white : Colors.white70,
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? Colors.white : (valueColor ?? Colors.white),
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
