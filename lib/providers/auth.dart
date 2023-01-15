import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_Exception.dart';

class Auth with ChangeNotifier {
   String _token = '';
   DateTime? _expiryDate = null;
   String _userid = '';
   Timer? authTimer = null;

  bool get isAuth {
    return token != "";
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != "") {
      return _token;
    }
    return "";
  }

  String get userId {
    return _userid;
  }

  Future<void> signup(String email, String password) async {
    await authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    await authenticate(email, password, 'signInWithPassword');
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    var url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDj1t4cIDzl1AgEi4bE5rwzt1z-NGsFYvI';
    try {
      var response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _token = responseData['idToken'];
      _userid = responseData['localId'];

    notifyListeners();
      _autoLogOut();

      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        'token': _token,
        'userId': _userid,
        'expiryDate': _expiryDate!.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
        jsonDecode(prefs.getString('userData') ?? '') as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    } 
    _expiryDate = expiryDate;
    _token = extractedData['token'] as String ;
    _userid = extractedData['userId'] as String;
    _autoLogOut();
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = '';
    _userid = '';
    _expiryDate = null;
    authTimer?.cancel();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogOut() {
    if (authTimer != null) {
      authTimer?.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timeToExpiry!), () => logout());
  }
}
