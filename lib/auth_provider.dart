import 'dart:convert';

import 'package:auth_example/helpers/api_exception.dart';
import 'package:auth_example/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  static final AuthProvider _instance = AuthProvider._internal();
  static String url = 'http://localhost:8081/';
  static String apiKey = 'a648bbc5-605a-4989-ba90-1386072c30cc';

  factory AuthProvider() => _instance;
  late SharedPreferences _prefs;

  AuthProvider._internal() {
    _initPrefs();
  }

  String? _username;

  String? get username => _username;

  String? _email;

  String? get email => _email;

  String? _password;

  String? get password => _password;

  // TODO: Don't store the password in shared preferences, rather use a secure storage solution;
  String? _jwt;

  String? get jwt => _jwt;

  bool get isLoggedIn => username != null && email != null && password != null;

  /// Initializes shared preferences
  Future<void> _initPrefs() async {
    // Initialize shared preferences
    _prefs = await SharedPreferences.getInstance();

    // Retrieve and update user information from shared preferences
    _username = _prefs.getString('username');
    _email = _prefs.getString('email');
    _password = _prefs.getString('password');
    _jwt = _prefs.getString('jwt');
    notifyListeners();
  }

  Future<void> updateEmailAndPassword(String email, String password) async {
    _email = email;
    _password = password;
    await _prefs.setString('email', email);
    await _prefs.setString('password', password);
    notifyListeners();
  }

  Future<void> signOut() async {
    _username = null;
    _email = null;
    _password = null;
    _jwt = null;
    await _prefs.clear();
    notifyListeners();
  }

  // Use a API key instead of a JWT because the JWT is only returned after the user has signed up
  Future<void> signUp(UserModel userModel) async {
    final requestURL = '${url}auth/signup';
    final request = http.Request('POST', Uri.parse(requestURL));
    request.headers.addAll({
      'Content-Type': 'application/json',
      'X-API-KEY': apiKey,
    });

    request.body = json.encode(userModel.toJson());

    final response = await request.send();
    if (response.statusCode == 200) {
      // We don't get the token yet, because the email isn't verified yet;
      // if we receive a 200 status code, the user has been created successfully;
    } else {
      final responseBody = await response.stream.bytesToString();
      throw APIException(response.statusCode, responseBody);
    }
  }

  Future<void> signIn(String email, String password) async {
    final requestURL = '${url}auth/signin';
    final request = http.Request('POST', Uri.parse(requestURL));
    request.headers.addAll({
      'Content-Type': 'application/json',
      'X-API-KEY': apiKey,
    });
    request.body = json.encode({
      'email': email,
      'password': password,
    });

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      final responseJSON = json.decode(responseString);
      _jwt = responseJSON['token'];
      updateEmailAndPassword(email, password);
      _prefs.setString('jwt', _jwt!);
      notifyListeners();
    } else {
      final responseBody = await response.stream.bytesToString();
      throw APIException(response.statusCode, responseBody);
    }
  }

  Future<bool> sendActivationEmail() async {
    final requestURL = '${url}auth/sendActivationEmail';
    final request = http.Request('POST', Uri.parse(requestURL));
    request.headers.addAll({
      'Content-Type': 'application/json',
      'X-API-KEY': apiKey,
    });

    request.body = json.encode({
      'email': email,
      'password': password,
    });

    final response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      final responseBody = await response.stream.bytesToString();
      throw Exception(responseBody);
    }
  }

  Future<void> activateAccount(String activationCode) async {
    final requestURL =
        '${url}auth/activateAccount?activationCode=$activationCode';
    final request = http.Request('POST', Uri.parse(requestURL));
    request.headers.addAll({
      'Content-Type': 'application/json',
      'X-API-KEY': apiKey,
    });

    request.body = json.encode({
      'email': email,
      'password': password,
    });

    final response = await request.send();
    if (response.statusCode == 200) {
      print(response.statusCode);
      // The account was activated successfully;
      // A JWT will be returned in the next login request;
    } else {
      final responseBody = await response.stream.bytesToString();
      throw APIException(response.statusCode, responseBody);
    }
  }

  Future<void> getProfile() async {}

  Future<void> deleteAccount() async {}
}
