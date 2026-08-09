import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../widgets/auth_text_field.dart';

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
        label: const Text('Thêm tài khoản', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: context.read<AuthProvider>().watchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi tải danh sách: ${snapshot.error}',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text('Chưa có tài khoản nào.', style: TextStyle(color: Colors.white54)),
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
              final isAdmin = role == 'admin';
              final isManager = role == 'manager';
              final isSelf = doc.id == currentUid;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isAdmin
                          ? Colors.blueAccent
                          : isManager
                              ? Colors.orangeAccent
                              : const Color(0xFF2C2C2E),
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
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
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isSelf) ...[
                                const SizedBox(width: 6),
                                const Text('(Bạn)', style: TextStyle(color: Colors.white38, fontSize: 12)),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email,
                            style: const TextStyle(color: Colors.white54, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isAdmin
                                  ? Colors.blueAccent.withValues(alpha: 0.15)
                                  : isManager
                                      ? Colors.orangeAccent.withValues(alpha: 0.15)
                                      : Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isAdmin ? 'Admin' : (isManager ? 'Manager' : 'User'),
                              style: TextStyle(
                                color: isAdmin
                                    ? Colors.blueAccent
                                    : isManager
                                        ? Colors.orangeAccent
                                        : Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.white54, size: 20),
                      onPressed: () => _openAccountForm(context, existing: doc),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: isSelf ? Colors.white24 : Colors.redAccent,
                        size: 20,
                      ),
                      onPressed: isSelf ? null : () => _confirmDelete(context, doc.id, name, email),
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

  Future<void> _confirmDelete(BuildContext context, String uid, String name, String email) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('Xóa tài khoản?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Xóa hồ sơ của "${name.isEmpty ? email : name}" khỏi hệ thống.\n\n'
          'Lưu ý: thao tác này chỉ xóa hồ sơ/quyền trong ứng dụng. Vì lý do bảo mật, ứng dụng di động không thể tự xóa hẳn đăng nhập của người khác — họ vẫn có thể đăng nhập lại bằng email/mật khẩu cũ nhưng sẽ không còn dữ liệu hồ sơ.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final error = await context.read<AuthProvider>().deleteUserProfile(uid);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
      );
    }
  }

  void _openAccountForm(BuildContext context, {QueryDocumentSnapshot<Map<String, dynamic>>? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AccountFormSheet(existing: existing),
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
  bool _isSubmitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final data = widget.existing?.data();
    _nameController = TextEditingController(text: data?['name'] as String? ?? '');
    _emailController = TextEditingController(text: data?['email'] as String? ?? '');
    _role = (data?['role'] as String?) ?? 'user';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final auth = context.read<AuthProvider>();

    final error = _isEditing
        ? await auth.updateUserProfile(
            widget.existing!.id,
            name: _nameController.text,
            role: _role,
          )
        : await auth.createAccountAsAdmin(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            role: _role,
          );

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
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                Text(
                  _isEditing ? 'Sửa tài khoản' : 'Thêm tài khoản mới',
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  controller: _nameController,
                  hint: 'Họ và tên',
                  icon: Icons.person_outline,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập họ tên' : null,
                ),
                const SizedBox(height: 14),
                if (_isEditing)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Text(
                      _emailController.text,
                      style: const TextStyle(color: Colors.white38, fontSize: 13),
                    ),
                  )
                else ...[
                  AuthTextField(
                    controller: _emailController,
                    hint: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Vui lòng nhập email';
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
                      if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
                      if (v.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
                      return null;
                    },
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
                        label: 'Manager',
                        selected: _role == 'manager',
                        onTap: () => setState(() => _role = 'manager'),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            _isEditing ? 'Lưu thay đổi' : 'Tạo tài khoản',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
  const _RoleChip({required this.label, required this.selected, required this.onTap});

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
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
