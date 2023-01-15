import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(this.id, this.title, this.price, this.quantity);
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingValue) => CartItem(existingValue.id, existingValue.title,
              existingValue.price, existingValue.quantity - 1));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingValue) => CartItem(existingValue.id, existingValue.title,
              existingValue.price, existingValue.quantity + 1));
    } else {
      _items.putIfAbsent(productId,
          () => CartItem(DateTime.now().toString(), title, price, 1));
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
