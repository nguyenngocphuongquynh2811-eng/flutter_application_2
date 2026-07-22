import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/banner_store.dart';
import '../../../models/admin/banner_model.dart';
import '../../product/edit_banner_sheet.dart';
import 'banner_card.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final banners = context.watch<BannerStore>().banners;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Banner",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              PopupMenuButton<String>(
                color: const Color(0xFF2C2C2E),
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onSelected: (value) {
                  switch (value) {
                    case "add":
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => const EditBannerSheet(),
                      );
                      break;

                    case "manage":
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => EditBannerSheet(
                          banners: banners,
                          selectedIndex: 0,
                        ),
                      );
                      break;
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: "add",
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 10),
                        Text("Thêm Banner"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: "manage",
                    child: Row(
                      children: [
                        Icon(Icons.photo_library),
                        SizedBox(width: 10),
                        Text("Quản lý Banner"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),        // Carousel Banner
        CarouselSlider.builder(
          itemCount: banners.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => EditBannerSheet(
                    banners: banners,
                    selectedIndex: index,
                  ),
                );
              },
              child: BannerCard(
                banner: banners[index],
              ),
            );
          },
          options: CarouselOptions(
            height: 250,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration:
                const Duration(milliseconds: 800),
          ),
        ),
      ],
    );
  }
}