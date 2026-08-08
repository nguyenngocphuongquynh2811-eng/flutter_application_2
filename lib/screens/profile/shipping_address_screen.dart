import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyController = TextEditingController();
  final _addressController = TextEditingController();
  final _address2Controller = TextEditingController();
  final _provinceController = TextEditingController();
  final _districtController = TextEditingController();
  final _wardController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isBusinessAddress = false;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    _address2Controller.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    _wardController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final authUser = context.read<AuthProvider>().currentUser;
    final nameParts = (authUser?.name ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    _firstNameController.text = nameParts.isNotEmpty ? nameParts.last : '';
    _lastNameController.text =
        nameParts.length > 1 ? nameParts.sublist(0, nameParts.length - 1).join(' ') : '';
    _emailController.text = authUser?.email ?? '';

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final saved = doc.data()?['shippingAddress'] as Map<String, dynamic>?;
      if (saved != null) {
        _firstNameController.text = saved['firstName'] as String? ?? _firstNameController.text;
        _lastNameController.text = saved['lastName'] as String? ?? _lastNameController.text;
        _companyController.text = saved['company'] as String? ?? '';
        _addressController.text = saved['address'] as String? ?? '';
        _address2Controller.text = saved['address2'] as String? ?? '';
        _provinceController.text = saved['province'] as String? ?? '';
        _districtController.text = saved['district'] as String? ?? '';
        _wardController.text = saved['ward'] as String? ?? '';
        _postalCodeController.text = saved['postalCode'] as String? ?? '';
        _phoneController.text = saved['phone'] as String? ?? '';
        _emailController.text = saved['email'] as String? ?? _emailController.text;
        _isBusinessAddress = saved['isBusiness'] as bool? ?? false;
      }
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _save() async {
    if (_firstNameController.text.trim().isEmpty || _lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ Họ và Tên.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isSaving = true);
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'shippingAddress': {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'company': _companyController.text.trim(),
        'address': _addressController.text.trim(),
        'address2': _address2Controller.text.trim(),
        'province': _provinceController.text.trim(),
        'district': _districtController.text.trim(),
        'ward': _wardController.text.trim(),
        'postalCode': _postalCodeController.text.trim(),
        'country': 'Việt Nam',
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'isBusiness': _isBusinessAddress,
      },
    }, SetOptions(merge: true));

    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu địa chỉ vận chuyển.'),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text("Hủy", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Vận Chuyển Chính",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                    onTap: _isLoading || _isSaving ? null : _save,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              "Lưu",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      children: [
                        const Text(
                          "Nếu bạn thay đổi thông tin vận chuyển trong ứng dụng Apple Store, thông tin vận chuyển của bạn trong iCloud cũng sẽ thay đổi.",
                          style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C2C2E),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              _linkRow("Nhập từ Danh Bạ"),
                              const Divider(color: Colors.white10, height: 1),
                              _linkRow("Sao Chép Địa Chỉ Thanh Toán"),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C2C2E),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              _fieldRow("Tên", _firstNameController),
                              _fieldRow("Họ", _lastNameController),
                              _fieldRow("Tên Công Ty", _companyController, placeholder: "Không bắt buộc"),
                              _fieldRow("Địa Chỉ", _addressController),
                              _fieldRow(
                                "Thông tin địa chỉ\nthứ hai",
                                _address2Controller,
                                placeholder: "Không bắt buộc",
                              ),
                              _fieldRow("Tên Tỉnh Trước\nSáp Nhập", _provinceController),
                              _fieldRow("Tên Quận Trước\nSáp Nhập", _districtController),
                              _fieldRow("Tên Phường Trước\nSáp Nhập", _wardController),
                              _fieldRow("Mã Bưu Điện", _postalCodeController, placeholder: "Không bắt buộc"),
                              _fieldRow("Quốc Gia/\nKhu Vực", null, isPlainText: true, plainValue: "Việt Nam"),
                              _fieldRow(
                                "Số Điện Thoại",
                                _phoneController,
                                keyboardType: TextInputType.phone,
                              ),
                              _fieldRow(
                                "Email",
                                _emailController,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              _switchRow("Đây là địa chỉ kinh doanh"),
                            ],
                          ),
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
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          color: const Color(0xFF1C1C1E),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.white54, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Tìm kiếm địa điểm hoặc địa...",
                    style: TextStyle(color: Colors.white54, fontSize: 15),
                  ),
                ),
                Icon(Icons.mic, color: Colors.white54, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _linkRow(String text) {
    return ListTile(
      dense: true,
      title: Text(text, style: const TextStyle(color: Colors.blueAccent, fontSize: 16)),
    );
  }

  Widget _fieldRow(
    String label,
    TextEditingController? controller, {
    String? placeholder,
    bool isPlainText = false,
    String? plainValue,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: isPlainText
                ? Text(
                    plainValue ?? '',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  )
                : TextField(
                    controller: controller,
                    textAlign: TextAlign.right,
                    keyboardType: keyboardType,
                    style: const TextStyle(color: Colors.blueAccent, fontSize: 15),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: placeholder ?? "Chưa có thông tin",
                      hintStyle: const TextStyle(color: Colors.white38, fontSize: 15),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _switchRow(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
          ),
          Switch(
            value: _isBusinessAddress,
            activeThumbColor: Colors.white,
            activeTrackColor: Colors.blueAccent,
            onChanged: (v) => setState(() => _isBusinessAddress = v),
          ),
        ],
      ),
    );
  }
}
