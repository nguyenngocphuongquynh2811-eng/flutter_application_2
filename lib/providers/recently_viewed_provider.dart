import 'package:flutter/foundation.dart';
import '../models/promo_card.dart';

class RecentlyViewedProvider with ChangeNotifier {
  static const int _maxItems = 10;

  final List<PromoCard> _items = [];

  List<PromoCard> get items => List.unmodifiable(_items);

  void markViewed(PromoCard card) {
    _items.removeWhere((item) => item.image == card.image);
    _items.insert(0, card);
    if (_items.length > _maxItems) {
      _items.removeRange(_maxItems, _items.length);
    }
    notifyListeners();
  }
}
