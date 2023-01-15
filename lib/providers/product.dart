import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_Exception.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  late bool isFavorite;

  Product(this.id, this.title, this.description, this.price, this.imageUrl,
      {this.isFavorite = false});

  Future<void> toggleIsFavorite(String token, String userId) async {
    var url = 'https://flutter-f798a-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    var existingFav = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();
    
     var response = await http.put(Uri.parse(url),
          body: jsonEncode(isFavorite
          ));
      if (response.statusCode >= 400) {
        isFavorite = existingFav;
      notifyListeners();
        throw HttpException('');
      } 
  }
}
