import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class AppleICloudDetailScreen extends StatelessWidget {
  const AppleICloudDetailScreen({super.key});

  void _showUpgradeSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã bắt đầu nâng cấp iCloud+!'),
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
          'iCloud+',
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
                              'Nhận dung lượng lưu trữ bạn cần, cùng quyền riêng tư bạn đáng có. ',
                        ),
                        TextSpan(
                          text: 'Nâng cấp iCloud+ ↗',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _showUpgradeSnackBar(context),
                        ),
                      ],
                    ),
                  ),
                ),

                _heroSection(context),

                _pricingSection(context),

                _infoRow(
                  title: 'Ảnh iCloud',
                  description:
                      'Lưu trữ trọn đời toàn bộ ảnh và video gốc có độ phân giải cao, tự động cập nhật trên mọi thiết bị.',
                ),
                _infoRow(
                  title: 'iCloud Drive',
                  description:
                      'Giúp bạn dễ dàng truy cập và chia sẻ các tập tin ở bất cứ đâu, trên bất kỳ thiết bị nào.',
                ),
                _infoRow(
                  title: 'Sao Lưu iCloud',
                  description:
                      'Tự động sao lưu dữ liệu iPhone, iPad khi được kết nối nguồn và Wi-Fi, khôi phục dễ dàng khi cần.',
                  showDivider: false,
                ),

                _privacySection(),

                _comparisonSection(),

                _closingCardsSection(context),

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
                  onPressed: () => _showUpgradeSnackBar(context),
                  child: const Text(
                    'Nâng cấp ngay hôm nay*',
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

  Widget _heroSection(BuildContext context) {
    final icons = [
      Icons.photo_outlined,
      Icons.cloud_queue,
      Icons.note_alt_outlined,
      Icons.chat_bubble_outline,
      Icons.alternate_email,
      Icons.backup_outlined,
      Icons.folder_outlined,
      Icons.sync,
      Icons.calendar_today_outlined,
      Icons.contacts_outlined,
      Icons.key_outlined,
      Icons.videocam_outlined,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(30, 40, 30, 50),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3E8CF3), Color(0xFF1E4FA8)],
        ),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 14,
            runSpacing: 14,
            alignment: WrapAlignment.center,
            children: icons
                .map(
                  (icon) => Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.cloud, color: Colors.white, size: 26),
              SizedBox(width: 6),
              Text(
                'iCloud+',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Một trải nghiệm kết nối mạnh mẽ.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'iCloud+ giữ cho ảnh, tập tin và mật khẩu của bạn luôn được cập '
            'nhật và bảo mật trên mọi thiết bị Apple, cùng các tính năng '
            'riêng tư nâng cao chỉ dành riêng cho người đăng ký.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pricingSection(BuildContext context) {
    final plans = [
      ('50GB', '25.000đ/tháng', 'Nơi lưu trữ hàng nghìn bức ảnh, video và tập tin.'),
      ('200GB', '89.000đ/tháng', 'Chia sẻ trong gia đình hoặc làm nơi lưu trữ thư viện media của bạn.'),
      ('2TB', '299.000đ/tháng', 'Nhiều không gian để lưu tất cả ảnh, video và tập tin của gia đình.'),
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFF1C1C1E),
      padding: const EdgeInsets.fromLTRB(22, 40, 0, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 22),
            child: Text(
              'Chọn gói phù hợp với bạn.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: plans.length,
              itemBuilder: (_, index) {
                final plan = plans[index];
                return Container(
                  width: 230,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.$1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plan.$2,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Text(
                          plan.$3,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blueAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => _showUpgradeSnackBar(context),
                          child: const Text(
                            'Nâng cấp',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600,
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

  Widget _infoRow({
    required String title,
    required String description,
    bool showDivider = true,
  }) {
    return Container(
      color: Colors.black,
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
        ],
      ),
    );
  }

  Widget _privacySection() {
    final items = [
      (
        Icons.vpn_lock_outlined,
        'iCloud Private Relay',
        'Bảo vệ quyền riêng tư khi duyệt web trên Safari, ngăn website theo dõi bạn qua địa chỉ IP.',
      ),
      (
        Icons.alternate_email,
        'Ẩn Email Của Tôi',
        'Tạo địa chỉ email ngẫu nhiên, chuyển tiếp về hộp thư thật của bạn mà không cần chia sẻ email chính.',
      ),
      (
        Icons.videocam_outlined,
        'HomeKit Secure Video',
        'Video từ camera an ninh được mã hóa đầu cuối, chỉ những người bạn chọn mới xem được.',
      ),
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFF1C1C1E),
      padding: const EdgeInsets.fromLTRB(22, 45, 22, 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quyền riêng tư nhiều hơn.\nBảo vệ tốt hơn. An tâm hơn.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 30),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.$1, color: Colors.blueAccent, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.$2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.$3,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
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

  Widget _comparisonSection() {
    final rows = [
      ('Dung lượng', '5GB', '50GB', '200GB', '2TB'),
      ('Đồng bộ tự động', '✓', '✓', '✓', '✓'),
      ('Private Relay', '—', '✓', '✓', '✓'),
      ('Ẩn Email Của Tôi', '—', '✓', '✓', '✓'),
      ('HomeKit Secure Video', '—', '1 camera', '5 camera', 'Không giới hạn'),
    ];

    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(22, 45, 22, 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'So sánh các gói.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              defaultColumnWidth: const FixedColumnWidth(110),
              border: TableBorder(
                horizontalInside: const BorderSide(color: Colors.white12),
              ),
              children: [
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                    _HeaderCell('Miễn phí'),
                    _HeaderCell('50GB'),
                    _HeaderCell('200GB'),
                    _HeaderCell('2TB'),
                  ],
                ),
                for (final row in rows)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          row.$1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _ValueCell(row.$2),
                      _ValueCell(row.$3),
                      _ValueCell(row.$4),
                      _ValueCell(row.$5),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _closingCardsSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1C1C1E),
      padding: const EdgeInsets.fromLTRB(22, 45, 22, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _closingCard(
            context: context,
            title: 'Chia Sẻ Trong Gia Đình',
            description:
                'Chia sẻ dung lượng lưu trữ với tối đa 5 thành viên gia đình, trong khi ảnh và tập tin cá nhân vẫn riêng tư.',
          ),
          const SizedBox(height: 16),
          _closingCard(
            context: context,
            title: 'Quyền Riêng Tư',
            description:
                'Các tính năng nâng cao như xác thực hai yếu tố và Bảo Vệ Dữ Liệu Nâng Cao giữ an toàn cho tài khoản của bạn.',
          ),
        ],
      ),
    );
  }

  Widget _closingCard({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    return GestureDetector(
      onTap: () => _showUpgradeSnackBar(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tìm hiểu thêm',
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ValueCell extends StatelessWidget {
  final String text;
  const _ValueCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
        ),
      ),
    );
  }
}
