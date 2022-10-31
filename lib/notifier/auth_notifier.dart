import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/user_service.dart';
import '../model/user.dart';

class AuthNotifier extends ChangeNotifier {
  String? _accessToken;
  String? get accessToken => _accessToken;

  User? _user;
  User? get user => _user;

  AuthNotifier() {
    SharedPreferences.getInstance().then((prefs) {
      var accessToken = prefs.getString('access_token');
      _accessToken = accessToken ?? "";
      if (_accessToken != "") {
        loadUser(_accessToken!);
      }
      notifyListeners();
    });
  }

  void loadUser(String jwt) {
    if (_user == null) {
      getUserProfile(jwt).then((value) {
        if (value.isSuccess()) {
          _user = value.getSuccess();
        } else if (value.getError() == '401') {
          _accessToken = "";
        } else {
          // print(value.getError());
        }
        notifyListeners();
      });
    }
  }

  void login(String token) {
    _accessToken = token;
    loadUser(token);
    notifyListeners();
  }

  void logout() {
    _accessToken = '';
    notifyListeners();
  }
}
