import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/mock_data.dart';
import '../../../data/shop_card_store.dart';
import '../../../models/shop_card.dart';

class EditShopCardSheet extends StatefulWidget {
  final List<ShopCard>? bigCards;
  final List<ShopCard>? smallCards;
  final int? selectedIndex;
  final bool isBig;

  const EditShopCardSheet({
    super.key,
    this.bigCards,
    this.smallCards,
    this.selectedIndex,
    this.isBig = true,
  });

  @override
  State<EditShopCardSheet> createState() => _EditShopCardSheetState();
}

class _EditShopCardSheetState extends State<EditShopCardSheet> {
  static const _colorOptions = [
    Colors.white,
    Colors.black,
    Color(0xFF2463EB),
    Colors.orange,
  ];

  int currentIndex = -1;
  bool isAddMode = false;
  bool isBigSelected = true;

  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController priceController;
  late TextEditingController priceNoteController;
  late TextEditingController tagController;

  late String selectedImage;
  late Color selectedColor;
  late List<String> allImages;

  @override
  void initState() {
    super.initState();

    allImages =
        MockData.featuredProducts.expand((e) => e.imagePaths).toSet().toList();

    if (widget.selectedIndex == null) {
      isAddMode = true;
      isBigSelected = widget.isBig;
      currentIndex = -1;

      titleController = TextEditingController();
      subtitleController = TextEditingController();
      priceController = TextEditingController();
      priceNoteController = TextEditingController();
      tagController = TextEditingController();
      selectedImage = allImages.first;
      selectedColor = Colors.white;
    } else {
      isBigSelected = widget.isBig;
      currentIndex = widget.selectedIndex!;
      final card = _listFor(isBigSelected)[currentIndex];

      titleController = TextEditingController(text: card.title);
      subtitleController = TextEditingController(text: card.subtitle);
      priceController = TextEditingController(text: card.price);
      priceNoteController = TextEditingController(text: card.priceNote ?? '');
      tagController = TextEditingController(text: card.tag ?? '');
      selectedImage = card.image;
      selectedColor = card.backgroundColor;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    priceController.dispose();
    priceNoteController.dispose();
    tagController.dispose();
    super.dispose();
  }

  List<ShopCard> _listFor(bool isBig) =>
      isBig ? widget.bigCards! : widget.smallCards!;

  void loadCard(int index, bool isBig) {
    final card = _listFor(isBig)[index];
    setState(() {
      currentIndex = index;
      isBigSelected = isBig;
      titleController.text = card.title;
      subtitleController.text = card.subtitle;
      priceController.text = card.price;
      priceNoteController.text = card.priceNote ?? '';
      tagController.text = card.tag ?? '';
      selectedImage = card.image;
      selectedColor = card.backgroundColor;
    });
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
            children: [
              Center(
                child: Text(
                  isAddMode ? "Thêm sản phẩm" : "Quản lý sản phẩm mới",
                  style:
                      const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              if (!isAddMode) ...[
                const Text("Danh sách",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 180,
                  child: ListView(
                    children: [
                      ...widget.bigCards!.asMap().entries.map(
                            (e) => _cardTile(e.value, e.key, true),
                          ),
                      ...widget.smallCards!.asMap().entries.map(
                            (e) => _cardTile(e.value, e.key, false),
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
              ],

              if (isAddMode) ...[
                const Text("Loại thẻ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text("Thẻ lớn"),
                        selected: isBigSelected,
                        onSelected: (_) =>
                            setState(() => isBigSelected = true),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text("Thẻ nhỏ"),
                        selected: !isBigSelected,
                        onSelected: (_) =>
                            setState(() => isBigSelected = false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              const Text("Ảnh", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: allImages.map((path) {
                  final selected = selectedImage == path;
                  return GestureDetector(
                    onTap: () => setState(() => selectedImage = path),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selected ? Colors.orange : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(path,
                            width: 90, height: 90, fit: BoxFit.cover),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              const Text("Màu nền",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: _colorOptions.map((c) {
                  final selected = selectedColor == c;
                  return GestureDetector(
                    onTap: () => setState(() => selectedColor = c),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? Colors.orange : Colors.white24,
                          width: selected ? 3 : 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              const Text("Tiêu đề",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "VD: MacBook Neo",
                ),
              ),

              const SizedBox(height: 20),
              const Text("Mô tả ngắn",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "VD: Điều tuyệt diệu của Mac.",
                ),
              ),

              const SizedBox(height: 20),
              const Text("Giá", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "VD: Từ 24.999.000đ",
                ),
              ),

              const SizedBox(height: 20),
              const Text("Ghi chú giá (không bắt buộc)",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: priceNoteController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "VD: hoặc 1.041.625đ/th. trong 24 tháng",
                ),
              ),

              const SizedBox(height: 20),
              const Text("Nhãn (không bắt buộc)",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: tagController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "VD: Mới",
                ),
              ),

              const SizedBox(height: 30),
              Row(
                children: [
                  if (!isAddMode)
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text("Xóa",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (currentIndex < 0) return;

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Xóa sản phẩm"),
                              content: const Text(
                                  "Bạn có chắc muốn xóa sản phẩm này?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Hủy"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<ShopCardStore>().deleteCard(
                                          currentIndex,
                                          isBig: isBigSelected,
                                        );
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Xóa",
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  if (!isAddMode) const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: Icon(isAddMode ? Icons.add : Icons.save,
                          color: Colors.white),
                      label: Text(isAddMode ? "Thêm sản phẩm" : "Lưu",
                          style: const TextStyle(color: Colors.white)),
                      onPressed: () {
                        if (titleController.text.trim().isEmpty ||
                            priceController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Vui lòng nhập tiêu đề và giá")),
                          );
                          return;
                        }

                        final card = ShopCard(
                          image: selectedImage,
                          title: titleController.text.trim(),
                          subtitle: subtitleController.text.trim(),
                          price: priceController.text.trim(),
                          priceNote: priceNoteController.text.trim().isEmpty
                              ? null
                              : priceNoteController.text.trim(),
                          tag: tagController.text.trim().isEmpty
                              ? null
                              : tagController.text.trim(),
                          backgroundColor: selectedColor,
                        );

                        final store = context.read<ShopCardStore>();
                        if (isAddMode) {
                          store.addCard(card, isBig: isBigSelected);
                        } else {
                          store.updateCard(currentIndex, card,
                              isBig: isBigSelected);
                        }

                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardTile(ShopCard card, int index, bool isBig) {
    final selected = currentIndex == index && isBigSelected == isBig;
    return Card(
      color: selected
          ? Colors.orange.withValues(alpha: .2)
          : const Color(0xFF1C1C1E),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(card.image, width: 45, height: 45, fit: BoxFit.cover),
        ),
        title: Text(card.title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(isBig ? "Thẻ lớn" : "Thẻ nhỏ",
            style: const TextStyle(color: Colors.grey)),
        onTap: () => loadCard(index, isBig),
      ),
    );
  }
}
