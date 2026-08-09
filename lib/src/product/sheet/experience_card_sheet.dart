import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_2/widgets/product_image.dart';

import '../../../data/experience_card_store.dart';
import '../../../data/cart_data.dart';

/// Mở form thêm/sửa thẻ "Tận hưởng trải nghiệm". index == null => thêm mới.
void openExperienceCardSheet(BuildContext context,
    {int? index, CardItemData? card}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _ExperienceCardSheet(index: index, card: card),
  );
}

class _ExperienceCardSheet extends StatefulWidget {
  final int? index;
  final CardItemData? card;
  const _ExperienceCardSheet({this.index, this.card});

  @override
  State<_ExperienceCardSheet> createState() => _ExperienceCardSheetState();
}

class _ExperienceCardSheetState extends State<_ExperienceCardSheet> {
  late final TextEditingController overlineC;
  late final TextEditingController titleC;
  late final TextEditingController subtitleC;
  String? image;
  int bgChoice = 0; // 0 = sáng, 1 = tối, 2 = xanh

  bool get isEdit => widget.index != null;

  @override
  void initState() {
    super.initState();
    final c = widget.card;
    overlineC = TextEditingController(text: c?.overline ?? '');
    titleC = TextEditingController(text: c?.title ?? '');
    subtitleC = TextEditingController(text: c?.subtitle ?? '');
    image = c?.image;
    if (c != null) {
      if (c.bgColor == const Color(0xFF0F0F10)) {
        bgChoice = 1;
      } else if (c.bgColor == const Color(0xFF2463EB)) {
        bgChoice = 2;
      } else {
        bgChoice = 0;
      }
    }
  }

  @override
  void dispose() {
    overlineC.dispose();
    titleC.dispose();
    subtitleC.dispose();
    super.dispose();
  }

  /// Trả về (màu nền, màu chữ) theo lựa chọn.
  (Color, Color) _colors() {
    switch (bgChoice) {
      case 1:
        return (const Color(0xFF0F0F10), Colors.white);
      case 2:
        return (const Color(0xFF2463EB), Colors.white);
      default:
        return (const Color(0xFFF5F5F7), Colors.black);
    }
  }

  Future<void> _pickFromDevice() async {
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
        .pickImage(source: source, imageQuality: 50, maxWidth: 1000);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => image = base64Encode(bytes));
  }

  void _save() {
    if (titleC.text.trim().isEmpty || image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập tiêu đề và chọn ảnh')),
      );
      return;
    }
    final (bg, txt) = _colors();
    final card = CardItemData(
      image: image!,
      overline: overlineC.text.trim().isEmpty ? null : overlineC.text.trim(),
      title: titleC.text.trim(),
      subtitle: subtitleC.text.trim(),
      bgColor: bg,
      textColor: txt,
    );
    final store = context.read<ExperienceCardStore>();
    isEdit ? store.updateCard(widget.index!, card) : store.addCard(card);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(isEdit ? 'Sửa thẻ trải nghiệm' : 'Thêm thẻ',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),

              if (image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ProductImage(image!,
                      height: 140, width: double.infinity),
                ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _pickFromDevice,
                  icon: const Icon(Icons.upload),
                  label: const Text('Tải ảnh từ máy'),
                ),
              ),

              const SizedBox(height: 16),
              _field('Nhãn nhỏ (tuỳ chọn, VD: Apple Arcade)', overlineC),
              _field('Tiêu đề', titleC),
              _field('Mô tả', subtitleC),

              const SizedBox(height: 8),
              const Text('Màu nền',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: [
                  _bgChip('Sáng', 0),
                  _bgChip('Tối', 1),
                  _bgChip('Xanh', 2),
                ],
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _save,
                  child: Text(isEdit ? 'Lưu' : 'Thêm',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bgChip(String label, int value) {
    final selected = bgChoice == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => bgChoice = value),
    );
  }

  Widget _field(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
