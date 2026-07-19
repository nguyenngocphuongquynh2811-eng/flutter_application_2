import 'package:flutter/material.dart';

class AccountBottomSheet extends StatelessWidget {
  const AccountBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.7,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1C1C1E),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(35),
            ),
          ),
          child: SafeArea(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                          border: Border.all(
                            color: Colors.white10,
                          ),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "Tài Khoản",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 38,
                        backgroundImage: AssetImage(
                          'assets/images/avatar.jpg',
                        ),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Quỳnh Phương",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              "nguyenngocphuongquynh2811@gmail.com",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                _section([
                  "Đặt trước",
                  "Đơn hàng",
                  "Thiết Bị",
                  "Dịch Vụ",
                  "Mục Đã Lưu",
                ]),

                const SizedBox(height: 24),

                _section([
                  "Thanh Toán Chính",
                  "Vận Chuyển Chính",
                  "Gửi Phản Hồi",
                  "Cài Đặt",
                ]),

                const SizedBox(height: 24),

                _singleItem("Nhận Trợ Giúp"),

                const SizedBox(height: 40),

                const Text(
                  "Chính Sách Bán Hàng và Hoàn Tiền của Apple",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  "Câu Hỏi Thường Gặp (FAQ)",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  "Xác Nhận",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  "Chính Sách Quyền Riêng Tư của Apple",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  "Xem cách quản lý dữ liệu của bạn...",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Copyright © 2026 Apple Inc. Mọi quyền được bảo lưu.",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _singleItem(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 22,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
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

  Widget _section(List<String> items) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: List.generate(
          items.length,
          (index) => Column(
            children: [
              ListTile(
                title: Text(
                  items[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white38,
                  size: 18,
                ),
              ),
              if (index != items.length - 1)
                const Divider(
                  color: Colors.white10,
                  height: 1,
                ),
            ],
          ),
        ),
      ),
    );
  }
}