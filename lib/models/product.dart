class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> imagePaths;
  final String categoryId;
  final String tag;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePaths,
    required this.categoryId,
    this.tag = "",
  });

  Product copyWith({
    String? name,
    String? description,
    double? price,
    List<String>? imagePaths,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imagePaths: imagePaths ?? this.imagePaths,
      categoryId: categoryId,
      tag: tag,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'price': price,
        'imagePaths': imagePaths,
        'categoryId': categoryId,
        'tag': tag,
      };

  factory Product.fromMap(String id, Map<String, dynamic> m) => Product(
        id: id,
        name: m['name'] ?? '',
        description: m['description'] ?? '',
        price: (m['price'] as num?)?.toDouble() ?? 0,
        imagePaths: List<String>.from(m['imagePaths'] ?? const []),
        categoryId: m['categoryId'] ?? '',
        tag: m['tag'] ?? '',
      );
}