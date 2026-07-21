import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class AppleMusicDetailScreen extends StatelessWidget {
  const AppleMusicDetailScreen({super.key});

  void _showTrialSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã bắt đầu dùng thử Apple Music miễn phí!'),
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
          'Apple Music',
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
            // Dòng thông báo ưu đãi
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
                          'Tặng 3 tháng sử dụng Apple Music miễn phí khi mua thiết bị đủ điều kiện.◊ ',
                    ),
                    TextSpan(
                      text: 'Kiểm tra tính phù hợp ↗',
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
            _infoRow(
              title: '1 tháng miễn phí dành cho người mới đăng ký',
              description:
                  'Người đăng ký mới sẽ nhận được 1 tháng sử dụng Apple Music miễn phí trước khi trả phí 65.000đ cho mỗi tháng.',
              linkText: 'Dùng thử miễn phí* ↗',
              onLinkTap: () => _showTrialSnackBar(context),
            ),
            _infoRow(
              title: '1 tháng sử dụng miễn phí với Apple One',
              description:
                  'Để được hưởng gói phí thấp hàng tháng, hãy gộp Apple Music với tối đa 5 dịch vụ tuyệt vời khác.',
              linkText: 'Dùng thử Apple One miễn phí⁴ ↗',
              onLinkTap: () => _showTrialSnackBar(context),
            ),
            _infoRow(
              title: 'Gói Dành Cho Sinh Viên đi kèm Apple TV+',
              description:
                  'Sinh viên sẽ nhận được 1 tháng sử dụng Apple Music miễn phí đi kèm quyền sử dụng Apple TV+.',
              linkText: 'Dùng thử miễn phí* ↗',
              onLinkTap: () => _showTrialSnackBar(context),
              showDivider: false,
            ),

            _discoverSection(),
            _exclusiveContentSection(),
            _devicesSection(),

            const SizedBox(height: 110),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
        color: const Color(0xFF1C1C1E),
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
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 70),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [Color(0xFFE8194B), Color(0xFF3D0713)],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.apple, color: Colors.white, size: 30),
              SizedBox(width: 6),
              Text(
                'Music',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'Thỏa niềm đam mê âm nhạc.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Nghe hơn 100 triệu bài hát, hoàn toàn không có quảng cáo. '
            'Cảm nhận chất âm đẳng cấp với tính năng Âm Thanh Không Gian¹ '
            'và âm thanh lossless.² Trở thành tâm điểm chú ý với Apple '
            'Music Sing.³ Truy cập các buổi phỏng vấn độc quyền và sự '
            'kiện âm nhạc trực tiếp. Và nghe trên mọi thiết bị, bất kể '
            'trực tuyến hay ngoại tuyến.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 36),
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

  Widget _infoRow({
    required String title,
    required String description,
    required String linkText,
    required VoidCallback onLinkTap,
    bool showDivider = true,
  }) {
    return Container(
      color: const Color(0xFF7A0C24),
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          if (showDivider) ...[
            const SizedBox(height: 16),
            Container(height: 1, color: Colors.white24),
          ],
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
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
                color: Colors.blueAccent,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _discoverSection() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF2F2F2),
      padding: const EdgeInsets.fromLTRB(22, 40, 22, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 24, height: 1.3),
              children: [
                TextSpan(
                  text: 'Khám phá âm nhạc. ',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      'Khám phá hơn 100 triệu bài hát và nhận đề xuất cá nhân hóa.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 260,
            child: Row(
              children: [
                Expanded(
                  child: _albumPlaceholder(
                    label: 'Love',
                    colors: const [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                    icon: Icons.favorite,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trang chủ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lựa chọn hàng đầu cho bạn',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.play_circle_fill,
                            color: Colors.white, size: 40),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _albumPlaceholder(
                    label: 'Catching Feelings',
                    colors: const [Color(0xFFF7971E), Color(0xFFFFD200)],
                    icon: Icons.music_note,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _albumPlaceholder({
    required String label,
    required List<Color> colors,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const Spacer(),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _exclusiveContentSection() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(22, 50, 22, 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF7A0C24), Colors.black],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.live_tv_rounded,
              color: Colors.white54,
              size: 60,
            ),
          ),
          const SizedBox(height: 24),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 22, height: 1.4),
              children: [
                TextSpan(
                  text: 'Nội dung độc quyền. ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      'Xem các buổi biểu diễn được truyền phát trực tiếp, truy '
                      'cập vào các buổi phỏng vấn chuyên sâu cũng như nghe các '
                      'đài phát thanh và chương trình radio phát trực tiếp.⁶',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _devicesSection() {
    final devices = [
      (Icons.phone_iphone, 'iPhone', null),
      (Icons.tablet_mac, 'iPad', null),
      (Icons.watch, 'Apple Watch', null),
      (Icons.laptop_mac, 'Mac', null),
      (Icons.tv, 'Apple TV', null),
      (Icons.phone_android, 'Android', 'Tải xuống từ Google Play'),
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(22, 50, 22, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nghe Apple Music trên mọi thiết bị của bạn.',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: devices.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 40,
              crossAxisSpacing: 20,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (_, index) {
              final device = devices[index];
              return Column(
                children: [
                  Icon(device.$1, size: 46, color: Colors.black87),
                  const SizedBox(height: 12),
                  Text(
                    device.$2,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (device.$3 != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      device.$3!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
