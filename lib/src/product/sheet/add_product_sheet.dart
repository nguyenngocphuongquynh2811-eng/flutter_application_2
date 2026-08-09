import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widgets/product_image.dart';
import '../../../data/mock_data.dart';
import '../../../data/product_store.dart';
import '../../../models/product.dart';

class AddProductSheet extends StatefulWidget {
  final String categoryId;
  const AddProductSheet({super.key, required this.categoryId});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final List<String> pickedImages = [];
  late final List<String> allImages;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    allImages = MockData.featuredProducts
        .expand((e) => e.imagePaths)
        .toSet()
        .toList();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descController.dispose();
    super.dispose();
  }

  void _pickImage() {
    showModalBottomSheet(
      context: context,
      builder: (_) => GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: allImages.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, i) {
          final path = allImages[i];
          return GestureDetector(
            onTap: () {
              if (!pickedImages.contains(path)) {
                setState(() => pickedImages.add(path));
              }
              Navigator.pop(context);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(path, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
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

    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 40,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    final base64Image = base64Encode(bytes);
    setState(() => pickedImages.add(base64Image));
  }

  Future<void> _save() async {
    final name = nameController.text.trim();
    final price =
        double.tryParse(priceController.text.replaceAll('.', '')) ?? 0;

    if (name.isEmpty || price <= 0 || pickedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nhập đủ tên, giá và chọn ít nhất 1 ảnh')),
      );
      return;
    }

    final newProduct = Product(
      id: 'p${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      price: price,
      description: descController.text.trim(),
      imagePaths: pickedImages,
      categoryId: widget.categoryId,
      tag: '',
    );

    setState(() => _isSaving = true);
    try {
      await context.read<ProductStore>().addProduct(newProduct);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains('longer than')
                ? 'Ảnh quá nặng (vượt giới hạn Firestore). Hãy chọn ít ảnh hơn hoặc ảnh nhẹ hơn.'
                : 'Không thể lưu sản phẩm: $e',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
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
              const Center(
                child: Text('Thêm sản phẩm',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 25),

              const Text('Ảnh sản phẩm',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Chọn ảnh có sẵn',
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickFromDevice,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Tải ảnh từ máy',
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: pickedImages.map((path) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ProductImage(path,
                            width: 90, height: 90, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () =>
                              setState(() => pickedImages.remove(path)),
                          child: const CircleAvatar(
                            radius: 11,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close,
                                size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),

              const SizedBox(height: 25),
              const Text('Tên sản phẩm',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'VD: iPhone 15 Pro Max',
                ),
              ),

              const SizedBox(height: 20),
              const Text('Giá (₫)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'VD: 28000000',
                ),
              ),

              const SizedBox(height: 20),
              const Text('Mô tả',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập mô tả sản phẩm',
                ),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Lưu',
                          style:
                              TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}