import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class AppleArcadeDetailScreen extends StatelessWidget {
  const AppleArcadeDetailScreen({super.key});

  void _showTrialSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã bắt đầu dùng thử Apple Arcade miễn phí!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Apple Arcade',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'Nhận 3 tháng Apple Arcade miễn phí khi mua iPhone, iPad, Apple TV 4K hoặc Mac mới. ',
                        ),
                        TextSpan(
                          text: 'Tìm hiểu thêm ↗',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _showTrialSnackBar(context),
                        ),
                      ],
                    ),
                  ),
                ),

                _heroSection(context),
                _featuresSection(),
                _plansSection(context),
                _gamesShowcaseSection(context),
                _devicesSection(),

                const SizedBox(height: 110),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: () => _showTrialSnackBar(context),
                  child: const Text(
                    'Dùng thử miễn phí*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- HERO ----------

  Widget _heroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 56, 28, 64),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF2D78), Color(0xFF8A3FFC), Color(0xFF3A5CFF)],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.apple, color: Colors.white, size: 22),
              SizedBox(width: 5),
              Text(
                'Arcade',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Chơi mọi lúc.\nKhông giới hạn.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w700,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Hàng trăm tựa game cao cấp, không quảng cáo, không mua trong app.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          const _GameIconCollage(),
        ],
      ),
    );
  }

  // ---------- FEATURES ----------

  Widget _featuresSection() {
    final items = [
      (
        Icons.videogame_asset_rounded,
        const Color(0xFFFF2D78),
        'Vui chơi cho mọi người',
        'Hàng trăm game trên iPhone, iPad, Mac, Apple TV và Vision Pro.',
      ),
      (
        Icons.wifi_off_rounded,
        const Color(0xFF3478F6),
        'Chơi online hoặc offline',
        'Trải nghiệm mượt mà trên mọi thiết bị Apple của bạn, có mạng hay không.',
      ),
      (
        Icons.block_rounded,
        const Color(0xFF32D74B),
        'Không quảng cáo. Không gián đoạn',
        'Không quảng cáo, không mua thêm trong ứng dụng — chỉ có niềm vui chơi game.',
      ),
      (
        Icons.group_rounded,
        const Color(0xFFFFD60A),
        'Chia sẻ với gia đình',
        'Chia sẻ 1 gói đăng ký với tối đa 5 thành viên trong gia đình.',
      ),
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: _IconRow(
                icon: item.$1,
                iconColor: item.$2,
                title: item.$3,
                description: item.$4,
              ),
            ),
        ],
      ),
    );
  }

  // ---------- PLANS ----------

  Widget _plansSection(BuildContext context) {
    final plans = [
      (
        'Thiết bị mới',
        '3 tháng miễn phí',
        'Dành cho khách hàng mua iPhone, iPad, Apple TV 4K hoặc Mac mới.',
        'Dùng thử 3 tháng',
      ),
      (
        'Apple One',
        '1 tháng miễn phí',
        'Gộp Apple Arcade với các dịch vụ Apple khác trong 1 gói duy nhất.',
        'Dùng thử 1 tháng',
      ),
      (
        'Chia Sẻ Gia Đình',
        '65.000đ/tháng',
        'Chia sẻ với tối đa 5 thành viên gia đình, mỗi người 1 tài khoản riêng.',
        'Bắt đầu ngay',
      ),
    ];

    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(24, 56, 0, 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 24),
            child: Text(
              'Chọn cách bạn muốn chơi.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 1.15,
                letterSpacing: -0.3,
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: plans.length,
              itemBuilder: (_, index) {
                final plan = plans[index];
                return Container(
                  width: 220,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.$1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plan.$2,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Text(
                          plan.$3,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 38,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blueAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
                            ),
                          ),
                          onPressed: () => _showTrialSnackBar(context),
                          child: Text(
                            plan.$4,
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------- GAMES SHOWCASE ----------

  Widget _gamesShowcaseSection(BuildContext context) {
    final genres = [
      ('Hành động', const Color(0xFFFF2D78)),
      ('Phiêu lưu', const Color(0xFF8A3FFC)),
      ('Giải đố', const Color(0xFF3478F6)),
      ('Đua xe', const Color(0xFF32D74B)),
      ('Thể thao', const Color(0xFFFF9F0A)),
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hành động. Phiêu lưu.\nGiải đố. Bắt đầu chơi thôi.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: genres
                .map(
                  (g) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: g.$2.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      g.$1,
                      style: TextStyle(
                        color: g.$2,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E824C), Color(0xFF0C3D22)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.pets, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sneaky Sasquatch',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Phiêu lưu · Game nổi bật',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white70),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _showTrialSnackBar(context),
            child: const Text(
              'Xem tất cả game →',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- DEVICES ----------

  Widget _devicesSection() {
    final devices = [
      (Icons.phone_iphone_rounded, 'iPhone'),
      (Icons.tablet_mac_rounded, 'iPad'),
      (Icons.laptop_mac_rounded, 'Mac'),
      (Icons.tv_rounded, 'Apple TV 4K'),
      (Icons.view_in_ar_rounded, 'Apple Vision Pro'),
    ];

    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chơi trên mọi thiết bị.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 28),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: devices.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1.6,
            ),
            itemBuilder: (_, index) {
              final device = devices[index];
              return Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(device.$1, size: 20, color: Colors.blueAccent),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      device.$2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Icon-in-circle + title + description row, shared across sections.
class _IconRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _IconRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Colorful game-icon collage placeholder for the hero section.
class _GameIconCollage extends StatelessWidget {
  const _GameIconCollage();

  @override
  Widget build(BuildContext context) {
    final tiles = [
      (Icons.pets, const Color(0xFF1E824C)),
      (Icons.sports_basketball, const Color(0xFFD94E2A)),
      (Icons.extension, const Color(0xFFE0B23F)),
      (Icons.directions_car_filled, const Color(0xFF3478F6)),
      (Icons.grid_view_rounded, const Color(0xFFE05C9A)),
      (Icons.sports_esports, const Color(0xFF8A3FFC)),
    ];

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      alignment: WrapAlignment.center,
      children: tiles
          .map(
            (tile) => Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: tile.$2,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(tile.$1, color: Colors.white, size: 26),
            ),
          )
          .toList(),
    );
  }
}
