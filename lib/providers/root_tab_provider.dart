import 'package:flutter/foundation.dart';

/// Tab hiện tại của RootScreen (Dành cho bạn/Sản phẩm/Xem thêm/Giỏ hàng/Tìm kiếm).
/// Tách ra Provider để các trang con (đẩy bằng Navigator.push, VD: xem danh
/// mục iPhone/Mac...) vẫn có thể hiển thị và thao tác đúng thanh điều hướng
/// dưới cùng mà không cần quay lại RootScreen trước.
class RootTabProvider extends ChangeNotifier {
  int _index = 1;

  int get index => _index;

  void setTab(int i) {
    if (_index == i) return;
    _index = i;
    notifyListeners();
  }
}
