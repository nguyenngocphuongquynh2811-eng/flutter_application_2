import 'package:flutter/material.dart';
class CardItemData {
  final String image;
  final String? overline;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color textColor;
  final VoidCallback? onTap;

  CardItemData({
    required this.image,
    this.overline,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.textColor,
    this.onTap,
  });
}