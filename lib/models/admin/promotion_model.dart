class PromotionModel {
  final String id;
  final String title;
  final String description;
  final String code;
  final double discountPercent;
  final String imagePath;
  final bool isActive;

  const PromotionModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.code,
    required this.discountPercent,
    required this.imagePath,
    this.isActive = true,
  });

  PromotionModel copyWith({
    String? title,
    String? description,
    String? code,
    double? discountPercent,
    String? imagePath,
    bool? isActive,
  }) {
    return PromotionModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      code: code ?? this.code,
      discountPercent: discountPercent ?? this.discountPercent,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive,
    );
  }
}
