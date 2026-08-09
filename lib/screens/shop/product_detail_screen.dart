import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../data/product_store.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/product_image.dart';

const _categoryNames = {
  'c1': 'Mac',
  'c2': 'iPhone',
  'c3': 'iPad',
  'c4': 'Apple Watch',
  'c5': 'AirPods',
};

// Categories that plausibly ship with an "Apple Intelligence" badge.
const _aiCapableCategories = {'c1', 'c2', 'c3'};

// Categories where a storage-tier picker makes sense when the product
// doesn't already declare its own [Product.storageOptions].
const _storageCapableCategories = {'c1', 'c2', 'c3'};

final _currency = NumberFormat("#,###", "vi_VN");

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late int _colorIndex;
  int _storageIndex = 0;
  bool _appleCareSelected = false;
  int _galleryPage = 0;

  Product get product => widget.product;

  String get _categoryName => _categoryNames[product.categoryId] ?? 'sản phẩm';

  List<String> get _colorLabels {
    if (product.imagePaths.length < 2) return const [];
    return List.generate(
      product.imagePaths.length,
      (i) => i < product.colorNames.length ? product.colorNames[i] : 'Màu ${i + 1}',
    );
  }

  List<ProductStorageOption> get _storageOptions {
    if (product.storageOptions.isNotEmpty) return product.storageOptions;
    if (!_storageCapableCategories.contains(product.categoryId)) return const [];
    return const [
      ProductStorageOption(label: '128GB', priceDelta: 0),
      ProductStorageOption(label: '256GB', priceDelta: 2500000),
      ProductStorageOption(label: '512GB', priceDelta: 5500000),
    ];
  }

  List<String> get _whatsInBox {
    if (product.whatsInBox.isNotEmpty) return product.whatsInBox;
    return const [
      'Cáp sạc USB-C',
      'Không đi kèm bộ tiếp hợp nguồn hoặc tai nghe',
    ];
  }

  double get _totalPrice {
    final options = _storageOptions;
    if (options.isEmpty) return product.price;
    return product.price + options[_storageIndex].priceDelta;
  }

  @override
  void initState() {
    super.initState();
    _colorIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final relatedProducts = product.relatedProductIds.isEmpty
        ? const <Product>[]
        : context
            .watch<ProductStore>()
            .products
            .where((p) => product.relatedProductIds.contains(p.id))
            .toList();

    final colorLabels = _colorLabels;
    final storageOptions = _storageOptions;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.black,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _circleButton(
                icon: Icons.chevron_left,
                onTap: () => Navigator.pop(context),
              ),
            ),
            actions: [
              _circleButton(icon: Icons.ios_share, onTap: () {}),
              const SizedBox(width: 8),
              _circleButton(icon: Icons.bookmark_border, onTap: () {}),
              const SizedBox(width: 16),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mua ${product.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_aiCapableCategories.contains(product.categoryId)) ...[
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Apple Intelligence',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const Text(
                          '³',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.info_outline, color: Colors.blueAccent, size: 16),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  Center(
                    child: Hero(
                      tag: 'product-${product.id}',
                      child: SizedBox(
                        height: 320,
                        child: ProductImage(
                          product.imagePaths[_colorIndex.clamp(0, product.imagePaths.length - 1)],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _pill('Tìm hiểu thêm'),
                      _pill('Thư viện'),
                      _pill('AR', icon: Icons.view_in_ar_outlined),
                    ],
                  ),

                  if (relatedProducts.isNotEmpty) ...[
                    const SizedBox(height: 40),
                    _sectionHeading('Phiên bản.', ' Mẫu nào phù hợp nhất với bạn?'),
                    const SizedBox(height: 16),
                    ...[product, ...relatedProducts].map((p) {
                      final selected = p.id == product.id;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: selected
                              ? null
                              : () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailScreen(product: p),
                                    ),
                                  ),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1C1E),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected ? Colors.blueAccent : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(p.tag.isNotEmpty ? p.tag : p.description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: Colors.white54, fontSize: 13)),
                                    ],
                                  ),
                                ),
                                Text('Từ ${_currency.format(p.price)}đ',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],

                  if (colorLabels.isNotEmpty) ...[
                    const SizedBox(height: 40),
                    _sectionHeading('Màu.', ' Chọn màu bạn yêu thích.'),
                    const SizedBox(height: 16),
                    Row(
                      children: List.generate(colorLabels.length, (i) {
                        final selected = i == _colorIndex;
                        return Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: GestureDetector(
                            onTap: () => setState(() => _colorIndex = i),
                            child: Column(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selected ? Colors.blueAccent : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: ProductImage(product.imagePaths[i], fit: BoxFit.cover),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(colorLabels[_colorIndex.clamp(0, colorLabels.length - 1)],
                        style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],

                  if (storageOptions.isNotEmpty) ...[
                    const SizedBox(height: 40),
                    _sectionHeading('Dung lượng lưu trữ.', ' Bạn cần bao nhiêu dung lượng?'),
                    const SizedBox(height: 16),
                    ...List.generate(storageOptions.length, (i) {
                      final option = storageOptions[i];
                      final selected = i == _storageIndex;
                      final tierPrice = product.price + option.priceDelta;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => setState(() => _storageIndex = i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1C1E),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected ? Colors.blueAccent : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(option.label,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold)),
                                Text('Từ ${_currency.format(tierPrice)}đ',
                                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    const Text(
                      'Trả góp theo tháng với phí dịch vụ thực tế, sau khi thanh toán lần đầu 20%. Có thêm tuỳ chọn thanh toán khi hoàn tất giao dịch.',
                      style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
                    ),
                  ],

                  const SizedBox(height: 32),
                  _expandableRow(
                    'Khám phá những điểm khác biệt về kích thước màn hình và thời lượng pin giữa các phiên bản.',
                  ),

                  const SizedBox(height: 40),
                  _sectionHeading('Apple Trade In.',
                      ' Nhận điểm tín dụng để sử dụng khi mua $_categoryName mới.'),
                  const SizedBox(height: 16),
                  _outlinedActionRow('Chọn $_categoryName của bạn'),

                  const SizedBox(height: 40),
                  _sectionHeading('Gói bảo hành AppleCare+.', ' Bảo vệ sản phẩm mới của bạn.'),
                  const SizedBox(height: 16),
                  _selectableRow(
                    label: 'AppleCare+',
                    selected: _appleCareSelected,
                    onTap: () => setState(() => _appleCareSelected = true),
                  ),
                  const SizedBox(height: 10),
                  _selectableRow(
                    label: 'Không có bảo hành AppleCare+',
                    selected: !_appleCareSelected,
                    onTap: () => setState(() => _appleCareSelected = false),
                  ),

                  if (product.imagePaths.length > 1) ...[
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 340,
                      child: PageView.builder(
                        itemCount: product.imagePaths.length,
                        onPageChanged: (i) => setState(() => _galleryPage = i),
                        itemBuilder: (_, i) => ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: ProductImage(product.imagePaths[i], fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        product.imagePaths.length,
                        (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _galleryPage ? Colors.white : Colors.white24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(product.name,
                          style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    ),
                  ],

                  const SizedBox(height: 40),
                  const Text('Tổng quan',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(product.description,
                      style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.6)),

                  const SizedBox(height: 32),
                  _iconInfoRow(Icons.local_shipping_outlined, 'Giao hàng nhanh miễn phí'),
                  const SizedBox(height: 16),
                  _iconInfoRow(Icons.card_giftcard_outlined,
                      'Thêm lời nhắn số miễn phí đi kèm quà tặng'),

                  const SizedBox(height: 20),
                  const Text('Trong hộp có gì',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ..._whatsInBox.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Icon(Icons.circle, size: 5, color: Colors.white54),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(item,
                                  style: const TextStyle(color: Colors.white70, fontSize: 15)),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 12),
                  const Divider(color: Colors.white10, height: 40),
                  _expansionSection(
                    'Thông Số Kĩ Thuật',
                    'Xem đầy đủ thông số kỹ thuật (kích thước, trọng lượng, camera, chip xử lý...) của $_categoryName này trên trang chi tiết sản phẩm.',
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  _expansionSection(
                    'Bảo Hành và AppleCare',
                    'Mọi $_categoryName mới đều được bảo hành theo tiêu chuẩn Apple. Nâng cấp lên AppleCare+ để được bảo vệ trước hư hỏng do va đập, rơi vỡ và hỗ trợ ưu tiên.',
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  _expansionSection(
                    'Câu Hỏi Thường Gặp',
                    'Bạn có thể đổi trả sản phẩm trong vòng 14 ngày. Thời gian giao hàng tiêu chuẩn từ 2-5 ngày làm việc. Liên hệ đội ngũ hỗ trợ nếu cần thêm thông tin.',
                  ),
                  const Divider(color: Colors.white10, height: 1),

                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {},
                    child: Text('So sánh các phiên bản $_categoryName mới nhất',
                        style: const TextStyle(color: Colors.blueAccent, fontSize: 15)),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('So sánh các phiên bản $_categoryName',
                            style: const TextStyle(color: Colors.blueAccent, fontSize: 15)),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, color: Colors.blueAccent, size: 18),
                      ],
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xFF1C1C1E),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Từ ${_currency.format(_totalPrice)}đ',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  final options = _storageOptions;
                  final chosenProduct = options.isEmpty
                      ? product
                      : product.copyWith(
                          price: _totalPrice,
                          name: '${product.name} ${options[_storageIndex].label}',
                        );
                  Provider.of<CartProvider>(context, listen: false).addItem(chosenProduct);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} đã được thêm vào giỏ hàng.'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.blueAccent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  );
                },
                child: const Text(
                  'Mua',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF1C1C1E),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _pill(String label, {IconData? icon}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
            ],
            Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeading(String bold, String rest) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(color: Colors.white, fontSize: 24, height: 1.3),
        children: [
          TextSpan(text: bold, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: rest),
        ],
      ),
    );
  }

  Widget _expandableRow(String text) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4)),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 14,
            backgroundColor: Colors.white24,
            child: Icon(Icons.add, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _outlinedActionRow(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _selectableRow({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? Colors.blueAccent : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selected ? Colors.blueAccent : Colors.white38,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconInfoRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ),
      ],
    );
  }

  Widget _expansionSection(String title, String content) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
        iconColor: Colors.white54,
        collapsedIconColor: Colors.white54,
        childrenPadding: const EdgeInsets.only(bottom: 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(content, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }
}
