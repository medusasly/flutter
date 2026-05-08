import 'package:flutter/material.dart';
import '../models/products.dart';

class CartProvider extends ChangeNotifier {
  final Map<Product, int> _items = {};

  Map<Product, int> get items => _items;

  void addItem(Product product) {
    if (_items.containsKey(product)) {
      _items[product] = _items[product]! + 1;
    } else {
      _items[product] = 1;
    }
    notifyListeners();
  }

  void increase(Product product) {
    _items[product] = _items[product]! + 1;
    notifyListeners();
  }

  void decrease(Product product) {
    if (_items[product]! > 1) {
      _items[product] = _items[product]! - 1;
    } else {
      _items.remove(product);
    }
    notifyListeners();
  }

  double get total {
    double total = 0;
    _items.forEach((product, qty) {
      total += product.price * qty;
    });
    return total;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
