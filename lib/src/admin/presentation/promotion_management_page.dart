import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/promotion_store.dart';
import '../../../models/admin/promotion_model.dart';

const _promoImages = [
  'assets/images/event_banner.jpg',
  'assets/images/today_banner.jpg',
  'assets/images/tv_banner.jpg',
  'assets/images/tradein.jpg',
  'assets/images/apple_music.jpg',
  'assets/images/apple_fitness.jpg',
  'assets/images/apple_arcade.jpg',
  'assets/images/apple_pay.jpg',
  'assets/images/icloud.jpg',
];

class PromotionManagementPage extends StatelessWidget {
  const PromotionManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<PromotionStore>();
    final promotions = store.promotions;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm khuyến mãi', style: TextStyle(color: Colors.white)),
      ),
      body: !store.isLoaded
          ? const Center(child: CircularProgressIndicator())
          : store.error != null
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Lỗi tải danh sách khuyến mãi: ${store.error}',
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : promotions.isEmpty
                  ? const Center(
                      child: Text('Chưa có chương trình khuyến mãi nào.',
                          style: TextStyle(color: Colors.white54)),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                      itemCount: promotions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _PromotionCard(promo: promotions[index]),
                    ),
    );
  }

  void _openForm(BuildContext context, {PromotionModel? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PromotionFormSheet(existing: existing),
    );
  }
}

class _PromotionCard extends StatelessWidget {
  const _PromotionCard({required this.promo});

  final PromotionModel promo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              promo.imagePath.isNotEmpty ? promo.imagePath : 'assets/images/event_banner.jpg',
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        promo.title,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Switch(
                      value: promo.isActive,
                      activeThumbColor: Colors.white,
                      activeTrackColor: Colors.blueAccent,
                      onChanged: (v) =>
                          context.read<PromotionStore>().setActive(promo.id, v),
                    ),
                  ],
                ),
                Text(
                  promo.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Giảm ${promo.discountPercent.toStringAsFixed(0)}%',
                        style: const TextStyle(
                            color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (promo.code.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Mã: ${promo.code}',
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.white54, size: 18),
                      onPressed: () =>
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => _PromotionFormSheet(existing: promo),
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                      onPressed: () => _confirmDelete(context, promo),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, PromotionModel promo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('Xoá khuyến mãi?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Xoá "${promo.title}" khỏi danh sách khuyến mãi.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xoá', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<PromotionStore>().deletePromotion(promo.id);
    }
  }
}

class _PromotionFormSheet extends StatefulWidget {
  const _PromotionFormSheet({this.existing});

  final PromotionModel? existing;

  @override
  State<_PromotionFormSheet> createState() => _PromotionFormSheetState();
}

class _PromotionFormSheetState extends State<_PromotionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _codeController;
  late final TextEditingController _discountController;
  late String _selectedImage;
  bool _isSubmitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleController = TextEditingController(text: e?.title ?? '');
    _descController = TextEditingController(text: e?.description ?? '');
    _codeController = TextEditingController(text: e?.code ?? '');
    _discountController =
        TextEditingController(text: e != null ? e.discountPercent.toStringAsFixed(0) : '');
    _selectedImage = e?.imagePath ?? _promoImages.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _codeController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final store = context.read<PromotionStore>();
    final promo = PromotionModel(
      id: widget.existing?.id ?? '',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      code: _codeController.text.trim().toUpperCase(),
      discountPercent: double.tryParse(_discountController.text.trim()) ?? 0,
      imagePath: _selectedImage,
      isActive: widget.existing?.isActive ?? true,
    );

    if (_isEditing) {
      await store.updatePromotion(widget.existing!.id, promo);
    } else {
      await store.addPromotion(promo);
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);
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
                  _isEditing ? 'Sửa khuyến mãi' : 'Thêm khuyến mãi mới',
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text('Ảnh', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _promoImages.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) {
                      final path = _promoImages[i];
                      final selected = path == _selectedImage;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedImage = path),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selected ? Colors.blueAccent : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: Image.asset(path, fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _label('Tiêu đề'),
                _field(_titleController, hint: 'VD: Giảm giá mùa hè',
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tiêu đề' : null),
                const SizedBox(height: 16),
                _label('Mô tả'),
                _field(_descController, hint: 'Mô tả ngắn về chương trình', maxLines: 3),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Mã giảm giá'),
                          _field(_codeController, hint: 'VD: SUMMER10'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Giảm (%)'),
                          _field(
                            _discountController,
                            hint: 'VD: 10',
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              final n = double.tryParse(v ?? '');
                              if (n == null || n <= 0 || n > 100) return 'Từ 1-100';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
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
                            _isEditing ? 'Lưu thay đổi' : 'Tạo khuyến mãi',
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

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 13)),
      );

  Widget _field(
    TextEditingController controller, {
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF2C2C2E),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
