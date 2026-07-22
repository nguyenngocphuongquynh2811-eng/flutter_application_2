import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/banner_store.dart';
import '../../../../data/mock_data.dart';
import '../../../models/admin/banner_model.dart';

class EditBannerSheet extends StatefulWidget {
  final List<BannerModel>? banners;
  final int? selectedIndex;

  const EditBannerSheet({
    super.key,
    this.banners,
    this.selectedIndex,
  });

  @override
  State<EditBannerSheet> createState() =>
      _EditBannerSheetState();
}

class _EditBannerSheetState
    extends State<EditBannerSheet> {

  late List<BannerModel> banners;

  int currentIndex = -1;

  late TextEditingController titleController;

  late TextEditingController subtitleController;

  late String selectedImage;

  late List<String> allImages;

  bool isAddMode = false;

  @override
  void initState() {
    super.initState();

    banners = widget.banners ?? [];

    if (widget.selectedIndex == null) {
      isAddMode = true;

      currentIndex = -1;

      titleController =
          TextEditingController();

      subtitleController =
          TextEditingController();

      allImages = MockData.featuredProducts
          .expand((e) => e.imagePaths)
          .toSet()
          .toList();

      selectedImage = allImages.first;
    } else {
      currentIndex = widget.selectedIndex!;

      final banner = banners[currentIndex];

      titleController =
          TextEditingController(
        text: banner.title,
      );

      subtitleController =
          TextEditingController(
        text: banner.subtitle,
      );

      selectedImage = banner.imagePath;

      allImages = MockData.featuredProducts
          .expand((e) => e.imagePaths)
          .toSet()
          .toList();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
  }

  void loadBanner(int index) {
    currentIndex = index;

    titleController.text =
        banners[index].title;

    subtitleController.text =
        banners[index].subtitle;

    selectedImage =
        banners[index].imagePath;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom:
              MediaQuery.of(context)
                      .viewInsets
                      .bottom +
                  20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Center(
                child: Text(
                  isAddMode
                      ? "Thêm Banner"
                      : "Quản lý Banner",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),              // Danh sách banner (chỉ hiện khi quản lý)
              if (!isAddMode) ...[
                const Text(
                  "Danh sách Banner",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      final banner = banners[index];

                      return Card(
                        color: currentIndex == index
                            ? Colors.orange.withValues(alpha: .2)
                            : const Color(0xFF1C1C1E),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(8),
                            child: Image.asset(
                              banner.imagePath,
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            banner.title,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            banner.subtitle,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {
                            loadBanner(index);
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),
              ],

              const Text(
                "Ảnh Banner",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: allImages.map((path) {

                  final selected =
                      selectedImage == path;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImage = path;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selected
                              ? Colors.orange
                              : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(8),
                        child: Image.asset(
                          path,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 25),

              const Text(
                "Tiêu đề",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nhập tiêu đề",
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Tiêu đề phụ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nhập tiêu đề phụ",
                ),
              ),

              const SizedBox(height: 30),              Row(
                children: [

                  if (!isAddMode)
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Xóa",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {

                          if (currentIndex < 0) {
                            return;
                          }

                          showDialog(
                            context: context,
                            builder: (context) {

                              return AlertDialog(
                                title: const Text(
                                  "Xóa Banner",
                                ),

                                content:
                                    const Text(
                                  "Bạn có chắc muốn xóa banner này?",
                                ),

                                actions: [

                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                    child:
                                        const Text(
                                      "Hủy",
                                    ),
                                  ),

                                  TextButton(
                                    onPressed: () {

                                      final store =
                                          context.read<
                                              BannerStore>();

                                      store.deleteBanner(
                                        currentIndex,
                                      );

                                      Navigator.pop(
                                        context,
                                      );

                                      Navigator.pop(
                                        context,
                                      );
                                    },

                                    child:
                                        const Text(
                                      "Xóa",
                                      style:
                                          TextStyle(
                                        color:
                                            Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),


                  if (!isAddMode)
                    const SizedBox(
                      width: 15,
                    ),


                  Expanded(
                    child: ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.orange,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),

                      icon: Icon(
                        isAddMode
                            ? Icons.add
                            : Icons.save,
                        color:
                            Colors.white,
                      ),

                      label: Text(
                        isAddMode
                            ? "Thêm Banner"
                            : "Lưu",
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                        ),
                      ),


                      onPressed: () {

                        if (titleController
                            .text
                            .trim()
                            .isEmpty) {

                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Vui lòng nhập tiêu đề",
                              ),
                            ),
                          );

                          return;
                        }


                        final banner =
                            BannerModel(
                          imagePath:
                              selectedImage,

                          title:
                              titleController.text,

                          subtitle:
                              subtitleController
                                  .text,
                        );


                        final store =
                            context.read<
                                BannerStore>();


                        if (isAddMode) {

                          store.addBanner(
                            banner,
                          );

                        } else {

                          store.updateBanner(
                            currentIndex,
                            banner,
                          );
                        }


                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                  ),
                ],
              ),            ],
          ),
        ),
      ),
    );
  }
}