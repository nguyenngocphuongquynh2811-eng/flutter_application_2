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
}
