import 'package:flutter/cupertino.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double totalAmount;
  final DateTime date;

  OrderItem(this.id, this.products, this.totalAmount, this.date);
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  String token;
  String userId;

  Order(this.token, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getOrders() async {
    var url =
        'https://flutter-f798a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';

    try {
      var response = await http.get(Uri.parse(url));
      var extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<OrderItem> list = [];
      if (extractedData.isNotEmpty) {
        extractedData.forEach((id, e) {
          list.add(OrderItem(
              id,
              (e['products'] as List<dynamic>)
                  .map((e) =>
                      CartItem(e['id'], e['title'], e['price'], e['quantity']))
                  .toList(),
              e['total'],
              DateTime.parse(e['date'])));
        });
      }
      _orders = list.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    var url =
        'https://flutter-f798a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    var time = DateTime.now();
    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          'total': total,
          'date': time.toIso8601String(),
          'products': products
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'price': e.price,
                    'quantity': e.quantity,
                  })
              .toList(),
        }));

    _orders.insert(
        0, OrderItem(jsonDecode(response.body)['name'], products, total, time));
    notifyListeners();
  }
}
