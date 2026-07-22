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

//====================ADMIN===================================
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
}


