import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool orderStatus = false;
  bool sessionNotification = false;
  bool promotionNotification = false;

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
                        'Thông Báo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 64),
                ],
              ),

              const SizedBox(height: 40),

              _buildNotificationItem(
                title: 'Trạng Thái Đơn Hàng',
                description:
                    'Thông báo cho tôi trên thiết bị này khi đơn hàng của tôi được vận chuyển, giao hoặc có sự thay đổi.',
                value: orderStatus,
                onChanged: (v) {
                  setState(() {
                    orderStatus = v;
                  });
                },
              ),

              const SizedBox(height: 30),

              _buildNotificationItem(
                title: 'Thông Báo Phiên',
                description:
                    'Gửi cho tôi thông báo và lời nhắc trên thiết bị này về các buổi Today at Apple.',
                value: sessionNotification,
                onChanged: (v) {
                  setState(() {
                    sessionNotification = v;
                  });
                },
              ),

              const SizedBox(height: 30),

              _buildNotificationItem(
                title: 'Thông Báo và Ưu Đãi',
                description:
                    'Gửi cho tôi thông báo từ Apple Store về sản phẩm mới, sự kiện đặc biệt của cửa hàng, đề xuất và chương trình khuyến mãi phù hợp với tôi.',
                value: promotionNotification,
                onChanged: (v) {
                  setState(() {
                    promotionNotification = v;
                  });
                },
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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
        ),

        const SizedBox(height: 14),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            description,
            style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
} 