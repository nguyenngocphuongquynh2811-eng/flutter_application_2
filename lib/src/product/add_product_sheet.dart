import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../data/product_store.dart';
import '../../models/product.dart';

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

  void _save() {
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

    context.read<ProductStore>().addProduct(newProduct);
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
              const Center(
                child: Text('Thêm sản phẩm',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 25),

              const Text('Ảnh sản phẩm',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm ảnh'),
                ),
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
                        child: Image.asset(path,
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
                  onPressed: _save,
                  child: const Text('Lưu',
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