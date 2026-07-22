import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class AppleFitnessDetailScreen extends StatelessWidget {
  const AppleFitnessDetailScreen({super.key});

  void _showTrialSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã bắt đầu dùng thử Apple Fitness+ miễn phí!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Apple Fitness+',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'Tặng 3 tháng sử dụng Apple Fitness+ miễn phí khi mua iPhone, Apple Watch, iPad hoặc Apple TV.¹ ',
                    ),
                    TextSpan(
                      text: 'Tìm hiểu thêm',
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

            _sectionLight(
              title:
                  '12 loại bài tập, từ Thể Lực, HIIT đến Yoga. Và cả Thiền Định.',
              child: _workoutGrid(),
            ),

            _darkImageBanner(
              text: 'Các buổi tập mới mỗi tuần. Từ 5 đến 45 phút.',
              onTap: () => _showTrialSnackBar(context),
            ),

            _plansSection(context),

            _sectionLight(
              title:
                  'Nâng cao trải nghiệm của bạn với các chỉ số trong khi tập luyện, theo thời gian thực từ Apple Watch.',
              child: _watchShowcase(),
            ),

            _discoverWorkoutsSection(),

            _infoRow(
              title: '3 tháng miễn phí',
              description:
                  'Người đăng ký mới sẽ nhận được 3 tháng sử dụng Apple Fitness+ miễn phí khi mua một thiết bị hợp lệ.¹',
              linkText: 'Tìm hiểu thêm',
              onLinkTap: () => _showTrialSnackBar(context),
            ),
            _infoRow(
              title: '1 tháng miễn phí',
              description:
                  'Người đăng ký mới sẽ được miễn phí 1 tháng rồi mới trả phí 69.000đ/tháng hoặc 499.000đ/năm.*',
              linkText: 'Dùng thử miễn phí',
              onLinkTap: () => _showTrialSnackBar(context),
              showDivider: false,
            ),

            _devicesSection(),

            Container(
              width: double.infinity,
              color: const Color(0xFFF2F2F2),
              padding: const EdgeInsets.fromLTRB(22, 40, 22, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Khám phá thêm về Apple Fitness+.',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _showTrialSnackBar(context),
                    child: const Text(
                      'Tìm hiểu thêm tại apple.com',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
              child: const Text(
                '* Cần có iPhone 8 trở lên hoặc Apple Watch Series 3 trở lên '
                'được ghép nối với iPhone 6s trở lên. Chỉ dành cho người đăng '
                'ký mới. Ưu đãi có thời hạn.',
                style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.5),
              ),
            ),

            const SizedBox(height: 110),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
        color: Colors.black,
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
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
    );
  }

  Widget _heroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 50),
      child: Column(
        children: [
          SizedBox(
            height: 260,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                _phoneMock(top: 0, colors: const [Color(0xFF3A3A3A), Color(0xFF1A1A1A)]),
                _phoneMock(top: 60, colors: const [Color(0xFF2E5D3A), Color(0xFF14251A)]),
                _phoneMock(top: 120, colors: const [Color(0xFF6A2E5D), Color(0xFF2A1424)]),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.apple, color: Colors.black, size: 26),
              SizedBox(width: 4),
              Text(
                'Fitness+',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Động lực để bắt đầu. Thúc đẩy tập luyện dài lâu.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
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
        ],
      ),
    );
  }

  Widget _phoneMock({required double top, required List<Color> colors}) {
    return Positioned(
      top: top,
      child: Container(
        width: 220,
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12, width: 2),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.fitness_center,
          color: Colors.white70,
          size: 30,
        ),
      ),
    );
  }

  Widget _sectionLight({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF2F2F2),
      padding: const EdgeInsets.fromLTRB(22, 45, 22, 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 30),
          child,
        ],
      ),
    );
  }

  Widget _workoutGrid() {
    final icons = [
      Icons.fitness_center,
      Icons.directions_run,
      Icons.self_improvement,
      Icons.sports_kabaddi,
      Icons.directions_bike,
      Icons.rowing,
    ];
    final colors = [
      const Color(0xFFB43C6B),
      const Color(0xFFD6467A),
      const Color(0xFF1F8A70),
      const Color(0xFFE0562A),
      const Color(0xFF2B5FAE),
      const Color(0xFF6B4226),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: icons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (_, index) {
        return Container(
          decoration: BoxDecoration(
            color: colors[index],
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Icon(icons[index], color: Colors.white, size: 32),
        );
      },
    );
  }

  Widget _darkImageBanner({
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 60, 22, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF241608), Color(0xFF0C0803)],
        ),
      ),
      child: Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: onTap,
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
        ],
      ),
    );
  }

  Widget _plansSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(22, 50, 22, 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Các Kế Hoạch Tùy Chỉnh giúp bạn duy trì động lực. '
            'Được thiết kế riêng cho bạn.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 30),
          _planCard(
            title: 'Duy trì sự nhất quán',
            subtitle: 'Thể Lực và Yoga',
            meta: '3 NGÀY • 20 PHÚT / NGÀY',
            colors: const [Color(0xFF5B4FE0), Color(0xFFE07A3F)],
          ),
          const SizedBox(height: 16),
          _planCard(
            title: 'Đẩy xa hơn',
            subtitle: 'Thể Lực và Yoga',
            meta: '3 NGÀY • 30 PHÚT / NGÀY',
            colors: const [Color(0xFFC23FC0), Color(0xFFE0A63F)],
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
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
        ],
      ),
    );
  }

  Widget _planCard({
    required String title,
    required String subtitle,
    required String meta,
    required List<Color> colors,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            meta,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _watchShowcase() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.watch, size: 50, color: Colors.black87),
          SizedBox(width: 16),
          Icon(Icons.smartphone, size: 60, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _discoverWorkoutsSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(22, 45, 22, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Khám phá nhiều cách tập luyện với Fitness+.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Row(
              children: [
                Expanded(
                  child: _discoverCard(
                    label: 'Nghệ Sĩ Nổi Bật',
                    colors: const [Color(0xFFE0B23F), Color(0xFF1A1A1A)],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _discoverCard(
                    label: 'Bộ Sưu Tập',
                    colors: const [Color(0xFFE0733F), Color(0xFFE0B23F)],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == 0 ? Colors.black87 : Colors.black26,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _discoverCard({required String label, required List<Color> colors}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      alignment: Alignment.topLeft,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoRow({
    required String title,
    required String description,
    required String linkText,
    required VoidCallback onLinkTap,
    bool showDivider = true,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showDivider) ...[
            const SizedBox(height: 16),
            Container(height: 1, color: Colors.black12),
          ],
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onLinkTap,
            child: Text(
              linkText,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _devicesSection() {
    final devices = [
      (Icons.phone_iphone, 'iPhone'),
      (Icons.tablet_mac, 'iPad'),
      (Icons.tv, 'Apple TV'),
      (Icons.watch, 'Apple Watch'),
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFFF2F2F2),
      padding: const EdgeInsets.fromLTRB(22, 45, 22, 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tìm ứng dụng Apple Fitness+ trên các thiết bị của bạn.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 36),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: devices.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 36,
              crossAxisSpacing: 20,
              childAspectRatio: 1.4,
            ),
            itemBuilder: (_, index) {
              final device = devices[index];
              return Column(
                children: [
                  Icon(device.$1, size: 42, color: Colors.black87),
                  const SizedBox(height: 10),
                  Text(
                    device.$2,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
