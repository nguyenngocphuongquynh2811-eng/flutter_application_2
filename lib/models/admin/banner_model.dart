class BannerModel {
  final String imagePath;
  final String title;
  final String subtitle;

  const BannerModel({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  BannerModel copyWith({
    String? imagePath,
    String? title,
    String? subtitle,
  }) {
    return BannerModel(
      imagePath: imagePath ?? this.imagePath,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  @override
  String toString() {
    return 'BannerModel(imagePath: $imagePath, title: $title, subtitle: $subtitle)';
  }
}