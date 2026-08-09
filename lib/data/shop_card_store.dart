import 'package:flutter/material.dart';

import '../models/shop_card.dart';
import 'mock_data.dart';

class ShopCardStore extends ChangeNotifier {
  final List<ShopCard> _bigCards = List.of(MockData.bigCards);
  final List<ShopCard> _smallCards = List.of(MockData.smallCards);

  List<ShopCard> get bigCards => _bigCards;
  List<ShopCard> get smallCards => _smallCards;

  void addCard(ShopCard card, {required bool isBig}) {
    (isBig ? _bigCards : _smallCards).add(card);
    notifyListeners();
  }

  void updateCard(int index, ShopCard card, {required bool isBig}) {
    (isBig ? _bigCards : _smallCards)[index] = card;
    notifyListeners();
  }

  void deleteCard(int index, {required bool isBig}) {
    (isBig ? _bigCards : _smallCards).removeAt(index);
    notifyListeners();
  }
}
