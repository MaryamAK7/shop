import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_Exception.dart';

import 'product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  String token;
  String userId;

  ProductsProvider(this.token, this.userId, this._items);

  List<Product> get favItems {
    _items
        .where((element) => element.isFavorite)
        .toList(); 
    return [..._items.where((element) => element.isFavorite).toList()];
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) async {
    var url =
        'https://flutter-f798a-default-rtdb.firebaseio.com/products.json?auth=$token';
    try {
      var response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imgaeURL': product.imageUrl,
            'creatorId': userId
          }));

      var newProduct = Product(json.decode(response.body)['name'],
          product.title, product.description, product.price, product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getProducts([bool filter = false]) async {
    final filterUrl = filter ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://flutter-f798a-default-rtdb.firebaseio.com/products.json?auth=$token&$filterUrl';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Product> loadedData = [];
      if (extractedData.isEmpty) {
        return;
      }
      url =
          'https://flutter-f798a-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$token';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = jsonDecode(favoriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedData.add(Product(prodId, prodData['title'],
            prodData['description'], prodData['price'], prodData['imgaeURL'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false));
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> editProduct(String id, Product product) async {
    var productIndex = _items.indexWhere((element) => element.id == id);
    var url =
        'https://flutter-f798a-default-rtdb.firebaseio.com/products/$id.json?auth=$token';
    if (productIndex >= 0) {
      await http.patch(Uri.parse(url),
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imgaeURL': product.imageUrl,
          }));
      _items[productIndex] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    var url =
        'https://flutter-f798a-default-rtdb.firebaseio.com/products/$id.json?auth=$token';
    var prodIndex = _items.indexWhere((element) => element.id == id);
    var exisitingProd = _items[prodIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    var response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(prodIndex, exisitingProd);
      notifyListeners();
      throw HttpException("Couldn't delete product");
    }
  }
}
