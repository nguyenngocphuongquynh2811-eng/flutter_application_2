import 'package:flutter/material.dart';
import 'country_screen.dart';
import 'notification_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool deviceEnabled = false;
  bool serviceEnabled = false;
  bool analyticsEnabled = true;
  String selectedCountry = 'Việt Nam';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Header
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white10,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Cài Đặt',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 64),
                ],
              ),

              const SizedBox(height: 30),

              // Notification Card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Thông Báo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white38,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 13),
                child: Text(
                  'Bật hoặc tắt thông báo từ ứng dụng Apple Store.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'Cá Nhân Hóa',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Main Card
              Container(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  18,
                  18,
                  14,
                ),               
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    _buildSettingItem(
                      title: 'Thiết Bị Của Bạn',
                      description:
                          'Chúng tôi sẽ sử dụng thiết bị được liên kết với Tài Khoản Apple của bạn, thông tin được tương tác giữa bạn với Apple và thông tin mua hàng từ Apple Store để hiển thị nội dung và cá nhân hoá, đề xuất sản phẩm và trạng thái AppleCare của bạn.',
                      value: deviceEnabled,
                      onChanged: (v) {
                        setState(() {
                          deviceEnabled = v;
                        });
                      },
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(
                        color: Colors.white10,
                        thickness: 0.8,
                        height: 1,
                      ),
                    ),

                    _buildSettingItem(
                      title: 'Dịch Vụ Của Bạn',
                      description:
                          'Chúng tôi sẽ sử dụng thông tin về các dịch vụ Apple có liên kết với Tài khoản Apple của bạn để hiển thị mọi gói đăng ký Apple hiện có, bản dùng thử miển phí và đề xuất cá nhân hoá đang có sẵn.',
                      value: serviceEnabled,
                      onChanged: (v) {
                        setState(() {
                          serviceEnabled = v;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 13),
                child: Text(
                    'Các cài đặt này sẽ đảm bảo cho bạn có thể truy cập vào nhiều tính năng ứng dụng hơn, xem được các nội dung liên quan và mua sắm dựa trên các đề xuất sản phẩm phù hợp.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  18,
                  18,
                  14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: _buildSettingItem(
                  title: 'Phân Tích',
                  description:
                    'Chúng tôi có thể sẽ thu thập hoạt động trong ứng dụng như các tìm kiếm, lịch sử duyệt web, mua hàng và các tương tác khác để tiến hành nâng cao và cải thiện trải nghiệm ứng dụng.',
                  value: analyticsEnabled,
                  onChanged: (v) {
                    setState(() {
                      analyticsEnabled = v;
                    });
                  },
                ),
              ),
              const SizedBox(height: 40),
              // QUỐC GIA / KHU VỰC
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 22,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Quốc Gia Hoặc Khu Vực:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CountryScreen(),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            selectedCountry = result;
                          });
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedCountry,
                            style: const TextStyle(
                              color: Color(0xFF0A84FF),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(width: 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 13),
                child: Text(
                  'Cập nhật quốc gia hoặc khu vực hiện tại của bạn để xem thông tin Apple Store có liên quan.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
 
    Widget _buildSettingItem({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => onChanged(!value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 62,
                height: 34,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: value
                  ? Colors.green
                  : const Color(0xFF636366),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  alignment:
                    value ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),

        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            description,
              style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}