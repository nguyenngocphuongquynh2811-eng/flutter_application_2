import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../widgets/auth_text_field.dart';

ImageProvider? _avatarProvider(String? base64Image) {
  if (base64Image == null || base64Image.isEmpty) return null;
  try {
    return MemoryImage(base64Decode(base64Image));
  } catch (_) {
    return null;
  }
}

class AccountManagementPage extends StatelessWidget {
  const AccountManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAccountForm(context),
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
        label: const Text('Thêm tài khoản',
            style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: context.read<AuthProvider>().watchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Lỗi tải danh sách: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text('Chưa có tài khoản nào.',
                  style: TextStyle(color: Colors.white54)),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();
              final name = (data['name'] as String?) ?? '';
              final email = (data['email'] as String?) ?? '';
              final role = (data['role'] as String?) ?? 'user';
              final avatar = _avatarProvider(data['avatarBase64'] as String?);
              final isAdmin = role == 'admin';
              final isSelf = doc.id == currentUid;

              final lockedTs = data['lockedUntil'];
              final lockedUntil =
                  lockedTs is Timestamp ? lockedTs.toDate() : null;
              final isLocked =
                  lockedUntil != null && lockedUntil.isAfter(DateTime.now());

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(16),
                  border: isLocked
                      ? Border.all(color: Colors.orangeAccent.withValues(alpha: 0.4))
                      : null,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isAdmin
                          ? Colors.blueAccent
                          : const Color(0xFF2C2C2E),
                      backgroundImage: avatar,
                      child: avatar == null
                          ? Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  name.isEmpty ? '(Chưa đặt tên)' : name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isSelf) ...[
                                const SizedBox(width: 6),
                                const Text('(Bạn)',
                                    style: TextStyle(
                                        color: Colors.white38, fontSize: 12)),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(email,
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 13),
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isAdmin
                                      ? Colors.blueAccent
                                          .withValues(alpha: 0.15)
                                      : Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(isAdmin ? 'Admin' : 'User',
                                    style: TextStyle(
                                        color: isAdmin
                                            ? Colors.blueAccent
                                            : Colors.white70,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600)),
                              ),
                              if (isLocked) ...[
                                const SizedBox(width: 8),
                                _LockCountdown(lockedUntil),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: Colors.white54, size: 20),
                      onPressed: () =>
                          _openAccountForm(context, existing: doc),
                    ),
                    // Khóa / Mở khóa (thay cho nút Xóa cũ)
                    if (isLocked)
                      IconButton(
                        icon: const Icon(Icons.lock_open,
                            color: Colors.greenAccent, size: 20),
                        tooltip: 'Mở khóa',
                        onPressed: () => _unlock(context, doc.id),
                      )
                    else
                      IconButton(
                        icon: Icon(Icons.lock_outline,
                            color: isSelf
                                ? Colors.white24
                                : Colors.orangeAccent,
                            size: 20),
                        tooltip: 'Khóa tài khoản',
                        onPressed: isSelf
                            ? null
                            : () => _openLockDialog(context, doc.id, name),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _unlock(BuildContext context, String uid) async {
    final err = await context.read<AuthProvider>().unlockUser(uid);
    if (err != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _openLockDialog(
      BuildContext context, String uid, String name) async {
    final controller = TextEditingController(text: '1');
    String unit = 'Tháng';

    final until = await showDialog<DateTime>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          backgroundColor: const Color(0xFF2C2C2E),
          title: Text('Khóa "${name.isEmpty ? 'tài khoản' : name}"',
              style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Chọn thời hạn khóa:',
                    style: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Số',
                        labelStyle: TextStyle(color: Colors.white54),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: unit,
                    dropdownColor: const Color(0xFF3A3A3C),
                    style: const TextStyle(color: Colors.white),
                    items: const [
                      DropdownMenuItem(value: 'Tháng', child: Text('Tháng')),
                      DropdownMenuItem(value: 'Năm', child: Text('Năm')),
                    ],
                    onChanged: (v) => setLocal(() => unit = v!),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Hủy',
                    style: TextStyle(color: Colors.white70))),
            TextButton(
              onPressed: () {
                final n = int.tryParse(controller.text.trim()) ?? 0;
                if (n <= 0) return;
                final now = DateTime.now();
                final result = unit == 'Năm'
                    ? DateTime(now.year + n, now.month, now.day, now.hour,
                        now.minute)
                    : DateTime(now.year, now.month + n, now.day, now.hour,
                        now.minute);
                Navigator.pop(ctx, result);
              },
              child: const Text('Khóa',
                  style: TextStyle(color: Colors.orangeAccent)),
            ),
          ],
        ),
      ),
    );

    if (until == null || !context.mounted) return;
    final err = await context.read<AuthProvider>().lockUser(uid, until);
    if (err != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err), backgroundColor: Colors.redAccent),
      );
    }
  }

  void _openAccountForm(BuildContext context,
      {QueryDocumentSnapshot<Map<String, dynamic>>? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AccountFormSheet(existing: existing),
    );
  }
}

/// Đếm ngược thời gian còn lại của khóa, tự cập nhật mỗi giây.
class _LockCountdown extends StatefulWidget {
  final DateTime until;
  const _LockCountdown(this.until);

  @override
  State<_LockCountdown> createState() => _LockCountdownState();
}

class _LockCountdownState extends State<_LockCountdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diff = widget.until.difference(DateTime.now());
    if (diff.isNegative) {
      return const Text('Hết hạn khóa',
          style: TextStyle(color: Colors.white38, fontSize: 11));
    }
    final d = diff.inDays;
    final h = diff.inHours % 24;
    final m = diff.inMinutes % 60;
    final s = diff.inSeconds % 60;
    final hh = h.toString().padLeft(2, '0');
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.lock, color: Colors.orangeAccent, size: 12),
        const SizedBox(width: 3),
        Text('Còn ${d}n $hh:$mm:$ss',
            style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _AccountFormSheet extends StatefulWidget {
  const _AccountFormSheet({this.existing});

  final QueryDocumentSnapshot<Map<String, dynamic>>? existing;

  @override
  State<_AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends State<_AccountFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController();
  late String _role;
  String? _avatarBase64;
  bool _isSubmitting = false;

  bool get _isEditing => widget.existing != null;

  bool get _isSelf =>
      _isEditing &&
      widget.existing!.id == FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    final data = widget.existing?.data();
    _nameController =
        TextEditingController(text: data?['name'] as String? ?? '');
    _emailController =
        TextEditingController(text: data?['email'] as String? ?? '');
    _role = (data?['role'] as String?) ?? 'user';
    _avatarBase64 = data?['avatarBase64'] as String?;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Chọn từ thư viện'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Chụp ảnh mới'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final picked = await ImagePicker()
        .pickImage(source: source, imageQuality: 40, maxWidth: 400);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => _avatarBase64 = base64Encode(bytes));
  }

  Future<void> _sendResetEmail() async {
    final auth = context.read<AuthProvider>();
    final error = await auth.sendPasswordResetEmail(_emailController.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Đã gửi email đặt lại mật khẩu.'),
        backgroundColor: error == null ? Colors.green : Colors.redAccent,
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final auth = context.read<AuthProvider>();

    String? error;
    if (_isEditing) {
      error = await auth.updateUserProfile(
        widget.existing!.id,
        name: _nameController.text,
        role: _role,
        avatarBase64: _avatarBase64,
      );
      if (error == null &&
          _isSelf &&
          _passwordController.text.trim().isNotEmpty) {
        error = await auth.changeOwnPassword(_passwordController.text.trim());
      }
    } else {
      error = await auth.createAccountAsAdmin(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _role,
      );
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
      );
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final avatar = _avatarProvider(_avatarBase64);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_isEditing ? 'Sửa tài khoản' : 'Thêm tài khoản mới',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                if (_isEditing)
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickAvatar,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: const Color(0xFF2C2C2E),
                            backgroundImage: avatar,
                            child: avatar == null
                                ? const Icon(Icons.camera_alt_outlined,
                                    color: Colors.white54)
                                : null,
                          ),
                        ),
                        TextButton(
                            onPressed: _pickAvatar,
                            child: const Text('Đổi ảnh')),
                      ],
                    ),
                  ),
                AuthTextField(
                  controller: _nameController,
                  hint: 'Họ và tên',
                  icon: Icons.person_outline,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Vui lòng nhập họ tên'
                      : null,
                ),
                const SizedBox(height: 14),
                if (_isEditing)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Text(_emailController.text,
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 13)),
                  )
                else ...[
                  AuthTextField(
                    controller: _emailController,
                    hint: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      if (!v.contains('@')) return 'Email không hợp lệ';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _passwordController,
                    hint: 'Mật khẩu',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      }
                      if (v.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                ],
                if (_isEditing && _isSelf) ...[
                  AuthTextField(
                    controller: _passwordController,
                    hint: 'Mật khẩu mới (bỏ trống nếu giữ nguyên)',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) return null;
                      if (v.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                ] else if (_isEditing && !_isSelf) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Không thể đặt mật khẩu cho người khác trực tiếp. Bạn có thể gửi email để họ tự đặt lại.',
                          style:
                              TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _sendResetEmail,
                          icon: const Icon(Icons.email_outlined, size: 18),
                          label: const Text('Gửi email đặt lại mật khẩu'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                Row(
                  children: [
                    Expanded(
                      child: _RoleChip(
                        label: 'User',
                        selected: _role == 'user',
                        onTap: () => setState(() => _role = 'user'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _RoleChip(
                        label: 'Admin',
                        selected: _role == 'admin',
                        onTap: () => setState(() => _role = 'admin'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            _isEditing ? 'Lưu thay đổi' : 'Tạo tài khoản',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.blueAccent : const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
