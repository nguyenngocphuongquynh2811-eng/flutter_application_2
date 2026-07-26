import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ApplePayDetailScreen extends StatelessWidget {
  const ApplePayDetailScreen({super.key});

  void _showAddCardSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã mở Ví để thêm thẻ!'),
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
          'Apple Pay',
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
                              'Thanh toán an toàn hơn, riêng tư hơn thẻ hay tiền mặt. ',
                        ),
                        TextSpan(
                          text: 'Thêm thẻ ↗',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _showAddCardSnackBar(context),
                        ),
                      ],
                    ),
                  ),
                ),

                _heroSection(context),
                _benefitsSection(),
                _setupSection(),
                _usageSection(),
                _securitySection(),
                _partnersSection(),
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
                  onPressed: () => _showAddCardSnackBar(context),
                  child: const Text(
                    'Thêm thẻ vào Ví*',
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
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(28, 56, 28, 64),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.apple, color: Colors.white, size: 22),
              SizedBox(width: 5),
              Text(
                'Pay',
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
            'Thanh toán\nkiểu Apple.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w700,
              height: 1.08,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Nhanh hơn, dễ dàng hơn dùng thẻ hay tiền mặt.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 17,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 44),
          _CardStack(),
        ],
      ),
    );
  }

  // ---------- BENEFITS ----------

  Widget _benefitsSection() {
    final items = [
      (
        Icons.privacy_tip_rounded,
        const Color(0xFF3478F6),
        'Quyền riêng tư và bảo mật tích hợp sẵn',
        'Apple không lưu dữ liệu có thể nhận diện bạn từ mỗi giao dịch.',
      ),
      (
        Icons.public_rounded,
        const Color(0xFF32D74B),
        'Được chấp nhận trên hàng triệu địa điểm',
        'Từ cửa hàng, taxi cho tới hàng ngàn ứng dụng và website.',
      ),
      (
        Icons.bolt_rounded,
        const Color(0xFFFFD60A),
        'Sẵn sàng rồi. Sử dụng thôi',
        'Thẻ ngân hàng bạn đang dùng có thể thêm vào Ví chỉ trong vài giây.',
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
              padding: const EdgeInsets.only(bottom: 32),
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

  // ---------- SETUP ----------

  Widget _setupSection() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thiết lập\ntrong nháy mắt.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Mở ứng dụng Ví, chạm vào biểu tượng dấu cộng, rồi làm theo '
            'các bước để thêm thẻ ghi nợ, thẻ tín dụng hoặc thẻ trả trước '
            'của bạn. Apple Pay luôn sẵn sàng ngay khi bạn cần.',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.add, color: Colors.black, size: 26),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Thêm thẻ trong ứng dụng Ví',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white38),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- USAGE ----------

  Widget _usageSection() {
    final items = [
      (
        Icons.storefront_rounded,
        const Color(0xFFFF9F0A),
        'Tại cửa hàng và nhiều nơi khác',
        'Chạm iPhone hoặc Apple Watch vào máy đọc thẻ để thanh toán, tại quán cà phê, siêu thị hay taxi.',
      ),
      (
        Icons.shopping_bag_rounded,
        const Color(0xFFBF5AF2),
        'Trong ứng dụng và trực tuyến',
        'Thanh toán chỉ với một chạm trong app hoặc trên Safari, không cần nhập số thẻ hay địa chỉ giao hàng.',
      ),
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dễ dàng.\nLàm mọi thứ.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 32),
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

  // ---------- SECURITY ----------

  Widget _securitySection() {
    final items = [
      (
        Icons.token_rounded,
        const Color(0xFF64D2FF),
        'Dữ liệu cá nhân. Được bảo vệ',
        'Số thẻ thật không được lưu trên thiết bị hay máy chủ Apple — mỗi giao dịch dùng một mã số riêng, được mã hóa.',
      ),
      (
        Icons.lock_rounded,
        const Color(0xFF32D74B),
        'Giao dịch mua hàng luôn được bảo mật',
        'Apple không biết bạn mua gì, ở đâu hay giá bao nhiêu.',
      ),
      (
        Icons.fingerprint_rounded,
        const Color(0xFFFF453A),
        'Quẹt Ví nhiều hơn. Tiếp xúc ít hơn',
        'Mỗi giao dịch cần xác thực bằng Face ID, Touch ID hoặc mã Apple Watch.',
      ),
    ];

    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'An toàn.\nVà bảo mật.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 32),
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

  // ---------- PARTNERS ----------

  Widget _partnersSection() {
    final banks = [
      'ACB', 'BIDV', 'MB', 'OCB', 'Sacombank',
      'Techcombank', 'TPBank', 'VIB', 'Vietcombank', 'VPBank',
    ];
    final merchants = [
      'Starbucks', "McDonald's", 'FPT Shop', 'CellphoneS',
      'Adidas', 'Decathlon', 'Điện Máy Xanh', 'Emart', 'Watsons',
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dùng theo\ncách bạn thích.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 32),
          _partnerGroup('NGÂN HÀNG HỖ TRỢ', banks),
          const SizedBox(height: 32),
          _partnerGroup('CHẤP NHẬN TẠI NHIỀU NƠI', merchants),
        ],
      ),
    );
  }

  Widget _partnerGroup(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items
              .map(
                (label) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // ---------- DEVICES ----------

  Widget _devicesSection() {
    final devices = [
      (Icons.phone_iphone_rounded, 'iPhone', 'Mở ứng dụng Ví và chạm vào dấu cộng để thêm thẻ.'),
      (Icons.watch_rounded, 'Apple Watch', 'Mở ứng dụng Apple Watch trên iPhone, chạm Ví & Apple Pay.'),
      (Icons.tablet_mac_rounded, 'iPad', 'Mở Cài Đặt → Ví & Apple Pay để thêm thẻ.'),
      (Icons.laptop_mac_rounded, 'Mac', 'Mở Tùy Chọn Hệ Thống → Ví & Apple Pay.'),
    ];

    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thiết lập trên\nthiết bị Apple.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 28),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: devices.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 14,
              childAspectRatio: 0.92,
            ),
            itemBuilder: (_, index) {
              final device = devices[index];
              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 14),
                    Text(
                      device.$2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      device.$3,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
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

/// Stylized stacked wallet-card graphic for the hero section.
class _CardStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 24,
            child: Transform.rotate(
              angle: -0.08,
              child: _card(
                width: 240,
                colors: const [Color(0xFF3A3A3C), Color(0xFF1C1C1E)],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Transform.rotate(
              angle: 0.04,
              child: _card(
                width: 260,
                colors: const [Color(0xFF0A84FF), Color(0xFF0040DD)],
                showLogo: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required double width,
    required List<Color> colors,
    bool showLogo = false,
  }) {
    return Container(
      width: width,
      height: 160,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(
                  4,
                  (i) => Container(
                    margin: const EdgeInsets.only(right: 4),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              if (showLogo)
                const Icon(Icons.wifi, color: Colors.white70, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}
