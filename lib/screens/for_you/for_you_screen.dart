import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/profile_avatar.dart';
import '../settings/settings_screen.dart';
import '../../data/mock_data.dart';
import '../../providers/recently_viewed_provider.dart';
import '../settings/notification_screen.dart';
import '../profile/account_bottom_sheet.dart';
import '../shop/apple_music_detail_screen.dart';
import '../shop/apple_fitness_detail_screen.dart';

class ForYouScreen extends StatelessWidget {
  const ForYouScreen({super.key});

  static Widget? _detailScreenFor(String image) {
    switch (image) {
      case 'assets/images/apple_music.jpg':
        return const AppleMusicDetailScreen();
      case 'assets/images/apple_fitness.jpg':
        return const AppleFitnessDetailScreen();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 16,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dành cho bạn',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => const AccountBottomSheet(),
                      );
                    },
                    child: const ProfileAvatar(),
                  ),
                ],
              ),
              background: Container(
                color: Colors.black,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<RecentlyViewedProvider>(
                    builder: (context, recentlyViewed, _) {
                      if (recentlyViewed.items.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hoạt động gần đây',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 280,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: recentlyViewed.items.length,
                              itemBuilder: (context, index) {
                                final item = recentlyViewed.items[index];
                                final screen = _detailScreenFor(item.image);
                                return GestureDetector(
                                  onTap: screen == null
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => screen,
                                            ),
                                          );
                                        },
                                  child: Container(
                                  width: 200,
                                  margin: const EdgeInsets.only(right: 16),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C1C1E),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Colors.tealAccent,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            'Đã Xem Gần Đây',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(16),
                                        child: Image.asset(
                                          item.image,
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        item.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      );
                    },
                  ),
                  const Text(
                    'Nội dung khác để bạn khám phá',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/apple_logo.jpg',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Cá nhân hoá trải nghiệm của bạn với Apple Store',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Bật Thiết Bị và Dịch Vụ để truy cập nhiều tính năng hơn và có được trải nghiệm cá nhân hoá hơn.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    icon: Icons.location_on_outlined,
                    iconColor: Colors.blue,
                    title: 'Chọn vị trí Apple Store\nbạn muốn.',
                    subtitle:
                     'Lưu Apple Store yêu thích của bạn để có trải nghiệm mua sắm tuyệt vời hơn.',
                  ),
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationScreen(),
                        ),
                      );
                    },
                    child: _buildInfoCard(
                      icon: Icons.notifications_none,
                      iconColor: Colors.redAccent,
                      title: 'Đón đầu mọi thông tin.',
                      subtitle:
                      'Bật thông báo để nhận đề xuất cá nhân hoá, chương trình khuyến mãi và giới thiệu sản phẩm mới.',
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Đừng bỏ lỡ những điều tuyệt vời nhất của Apple',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: MockData.promoCards.length,
                      itemBuilder: (context, index) {
                        final item = MockData.promoCards[index];
                        final screen = _detailScreenFor(item.image);
                        return GestureDetector(
                          onTap: screen == null
                              ? null
                              : () {
                                  context
                                      .read<RecentlyViewedProvider>()
                                      .markViewed(item);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => screen,
                                    ),
                                  );
                                },
                          child: Container(
                          width: 260,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C1E),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                // Ảnh
                              Container(
                                height: 220,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(30),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(item.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            // Nội dung
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (item.category.isNotEmpty) ...[
                                        Text(
                                          item.category,
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),  
                                        ),  
                                        const SizedBox(height: 8),
                                      ],

                                      Text(
                                        item.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 8),
                                      Text(
                                      item.subtitle,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),

                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ),
                        );
                      },
                    ),
                  ),          
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 42,
            color: iconColor,
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white38,
            size: 18,
          ),
        ],
      ),
    );
  }
}
