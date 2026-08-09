import 'dart:convert';
import 'package:flutter/material.dart';

/// Trả về ImageProvider đúng loại: asset hay base64 (ảnh tải từ máy).
/// Dùng cho DecorationImage, Hero, CircleAvatar... nơi cần ImageProvider.
ImageProvider productImageProvider(String source) {
  if (source.startsWith('assets/')) {
    return AssetImage(source);
  }
  try {
    return MemoryImage(base64Decode(source));
  } catch (_) {
    return const AssetImage('assets/images/iphone.jpg'); // ảnh dự phòng
  }
}

/// Widget hiển thị ảnh sản phẩm dù là asset (assets/...) hay base64 (ảnh tải từ máy).
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