import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../data/mock_data.dart';
import '../../../../../data/product_store.dart';
import '../../../../../models/product.dart';

class EditProductSheet extends StatefulWidget {
  final Product product;
  final List<Product> allProducts;

  const EditProductSheet({
    super.key,
    required this.product,
    required this.allProducts,
  });

  @override
  State<EditProductSheet> createState() => _EditProductSheetState();
}

class _EditProductSheetState extends State<EditProductSheet> {
  late List<String> editedImages;

  late String selectedImage;

  late TextEditingController descController;

  late TextEditingController NameController;

  late TextEditingController PriceController;

  late List<String> allImages;

  @override
  void initState() {
    super.initState();

    editedImages = List.of(widget.product.imagePaths);

    selectedImage = editedImages.first;

    descController =
        TextEditingController(text: widget.product.description);

    NameController = TextEditingController(text: widget.product.name);

    PriceController = TextEditingController(text: widget.product.price.toString());

    allImages = MockData.featuredProducts
        .expand((e) => e.imagePaths)
        .toSet()
        .toList();
  }

  @override
  void dispose() {
    NameController.dispose();
    PriceController.dispose();
    descController.dispose();
    super.dispose();
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
                child: Text(
                  "Chỉnh sửa sản phẩm",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Ảnh sản phẩm",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return GridView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: allImages.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (_, index) {
                            final path = allImages[index];

                            return GestureDetector(
                              onTap: () {
                                if (!editedImages.contains(path)) {
                                  setState(() {
                                    editedImages.add(path);
                                  });
                                }

                                Navigator.pop(context);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  path,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Thêm ảnh"),
                ),
              ),

              const SizedBox(height: 15),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: editedImages.map((path) {
                  final selected = selectedImage == path;

                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImage = path;

                            editedImages.remove(path);

                            editedImages.insert(0, path);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  selected ? Colors.orange : Colors.grey,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              path,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            if (editedImages.length == 1) return;

                            setState(() {
                              editedImages.remove(path);

                              if (selectedImage == path) {
                                selectedImage = editedImages.first;
                              }
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(2),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),

              const SizedBox(height: 25),
                            const Text(
                "Mô tả",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nhập mô tả sản phẩm",
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Sản phẩm",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                NameController.text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "${NumberFormat("#,###", "vi_VN").format(double.parse(PriceController.text))} ₫",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return SafeArea(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.allProducts.length,
                          itemBuilder: (_, index) {
                            final p = widget.allProducts[index];

                            return ListTile(
                              leading: Image.asset(
                                p.imagePaths.first,
                                width: 45,
                                height: 45,
                                fit: BoxFit.cover,
                              ),
                              title: Text(p.name),
                              subtitle: Text(
                                "${NumberFormat("#,###", "vi_VN").format(p.price)} ₫",
                              ),
                              onTap: () {
                                setState(() {
                                  NameController.text = p.name;
                                  PriceController.text = p.price.toString();
                                });

                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                },
                child: const Text("Chọn sản phẩm mẫu"),
              ),

              const SizedBox(height: 20),
              const Text("Tên sản phẩm",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: NameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nhập tên sản phẩm",
                ),
              ),

              const SizedBox(height: 20),
              const Text("Giá (₫)",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: PriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nhập giá",
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
                  onPressed: () {
                    final updated = widget.product.copyWith(
                      name: NameController.text.trim(),
                      price: double.tryParse(PriceController.text.replaceAll(".", "")) ?? widget.product.price,
                      description: descController.text,
                      imagePaths: editedImages,
                    );

                    context
                        .read<ProductStore>()
                        .updateProduct(widget.product.id, updated);

                    Navigator.pop(context); // đóng sheet

                    Navigator.pop(context); // quay về danh sách
                  },
                  child: const Text(
                    "Lưu",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}