class ProductStorageOption {
  final String label;
  final double priceDelta;

  const ProductStorageOption({required this.label, this.priceDelta = 0});

  Map<String, dynamic> toMap() => {'label': label, 'priceDelta': priceDelta};

  factory ProductStorageOption.fromMap(Map<String, dynamic> m) =>
      ProductStorageOption(
        label: m['label'] as String? ?? '',
        priceDelta: (m['priceDelta'] as num?)?.toDouble() ?? 0,
      );
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> imagePaths;
  final String categoryId;
  final String tag;

  /// Tên màu song song với [imagePaths] (ảnh thứ i ứng với màu thứ i).
  /// Rỗng nếu sản phẩm chỉ có 1 màu / chưa khai báo.
  final List<String> colorNames;

  /// Các tuỳ chọn dung lượng, mỗi tuỳ chọn cộng thêm [priceDelta] vào [price].
  /// Rỗng nếu sản phẩm không có lựa chọn dung lượng (VD: phụ kiện).
  final List<ProductStorageOption> storageOptions;

  /// Danh sách vật phẩm đi kèm trong hộp. Rỗng thì dùng danh sách mặc định.
  final List<String> whatsInBox;

  /// id của các sản phẩm "cùng dòng" (VD: Pro / Pro Max) để hiện mục "Phiên bản".
  final List<String> relatedProductIds;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePaths,
    required this.categoryId,
    this.tag = "",
    this.colorNames = const [],
    this.storageOptions = const [],
    this.whatsInBox = const [],
    this.relatedProductIds = const [],
  });

  Product copyWith({
    String? name,
    String? description,
    double? price,
    List<String>? imagePaths,
    List<String>? colorNames,
    List<ProductStorageOption>? storageOptions,
    List<String>? whatsInBox,
    List<String>? relatedProductIds,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imagePaths: imagePaths ?? this.imagePaths,
      categoryId: categoryId,
      tag: tag,
      colorNames: colorNames ?? this.colorNames,
      storageOptions: storageOptions ?? this.storageOptions,
      whatsInBox: whatsInBox ?? this.whatsInBox,
      relatedProductIds: relatedProductIds ?? this.relatedProductIds,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'price': price,
        'imagePaths': imagePaths,
        'categoryId': categoryId,
        'tag': tag,
        'colorNames': colorNames,
        'storageOptions': storageOptions.map((e) => e.toMap()).toList(),
        'whatsInBox': whatsInBox,
        'relatedProductIds': relatedProductIds,
      };

  factory Product.fromMap(String id, Map<String, dynamic> m) => Product(
        id: id,
        name: m['name'] ?? '',
        description: m['description'] ?? '',
        price: (m['price'] as num?)?.toDouble() ?? 0,
        imagePaths: List<String>.from(m['imagePaths'] ?? const []),
        categoryId: m['categoryId'] ?? '',
        tag: m['tag'] ?? '',
        colorNames: List<String>.from(m['colorNames'] ?? const []),
        storageOptions: (m['storageOptions'] as List? ?? const [])
            .map((e) => ProductStorageOption.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList(),
        whatsInBox: List<String>.from(m['whatsInBox'] ?? const []),
        relatedProductIds: List<String>.from(m['relatedProductIds'] ?? const []),
      );
}
