import 'dart:convert';
import 'package:flutter/material.dart';

/// Hiển thị ảnh sản phẩm dù là asset (assets/...) hay base64 (ảnh tải từ máy).
class ProductImage extends StatelessWidget {
  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ProductImage(
    this.source, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  bool get _isAsset => source.startsWith('assets/');

  /// ImageProvider tương ứng, dùng cho DecorationImage/CircleAvatar.
  static ImageProvider provider(String source) {
    if (source.startsWith('assets/')) {
      return AssetImage(source);
    }
    try {
      return MemoryImage(base64Decode(source));
    } catch (_) {
      return MemoryImage(base64Decode(_transparentPixel));
    }
  }

  static const _transparentPixel =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=';

  @override
  Widget build(BuildContext context) {
    if (_isAsset) {
      return Image.asset(source, width: width, height: height, fit: fit);
    }
    try {
      return Image.memory(base64Decode(source),
          width: width, height: height, fit: fit);
    } catch (_) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey.shade800,
        child: const Icon(Icons.broken_image, color: Colors.white54),
      );
    }
  }
}