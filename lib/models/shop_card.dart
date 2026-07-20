import 'package:flutter/material.dart';

class ShopCard {
  final String image;
  final String title;
  final String subtitle;
  final String price;
  final Color backgroundColor;
  final String? tag;
  final String? priceNote;

  const ShopCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.backgroundColor,
    this.tag,
    this.priceNote,
  });
}