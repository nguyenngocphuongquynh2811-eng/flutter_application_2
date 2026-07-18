import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Khám phá',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              background: Container(color: Colors.black),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildDiscoverCard(
              context,
              title: 'Apple Event',
              subtitle: 'Sự kiện đặc biệt. Theo dõi trực tiếp.',
              imagePath: 'assets/images/event_banner.jpg',
            ),
          ),
          SliverToBoxAdapter(
            child: _buildDiscoverCard(
              context,
              title: 'Today at Apple',
              subtitle: 'Nâng cao kỹ năng với các buổi học miễn phí.',
              imagePath: 'assets/images/today_banner.jpg',
            ),
          ),
          SliverToBoxAdapter(
            child: _buildDiscoverCard(
              context,
              title: 'Apple TV+',
              subtitle: 'Các chương trình độc quyền hàng tháng.',
              imagePath: 'assets/images/tv_banner.jpg',
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  Widget _buildDiscoverCard(BuildContext context, {required String title, required String subtitle, required String imagePath}) {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.9),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
