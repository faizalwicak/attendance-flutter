import 'package:attendance_flutter/api/clock_service.dart';
import 'package:attendance_flutter/api/quote_service.dart';
import 'package:attendance_flutter/model/quote.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/user_service.dart';
import '../model/record.dart';
import '../model/user.dart';

class AuthNotifier extends ChangeNotifier {
  String? _accessToken;
  String? get accessToken => _accessToken;

  User? _user;
  User? get user => _user;

  Record? _clockStatus;
  Record? get clockStatus => _clockStatus;

  Quote? _quote;
  Quote? get quote => _quote;

  AuthNotifier() {
    SharedPreferences.getInstance().then((prefs) {
      var accessToken = prefs.getString('access_token');
      _accessToken = accessToken ?? "";
      if (_accessToken != "") {
        loadUser();
      }
      notifyListeners();
    });
  }

  void loadUser() {
    if (_user == null) {
      freshLoadUser();
    }
  }

  void freshLoadUser() {
    getUserProfile(_accessToken ?? "").then((value) {
      if (value.isSuccess()) {
        _user = value.getSuccess();
      } else if (value.getError() == '401') {
        _accessToken = "";
      } else {
        print(value.getError());
      }
      notifyListeners();
    });
    loadClockStatus();
    loadQuote();
  }

  void loadClockStatus() {
    getClockStatus(_accessToken ?? "").then((value) {
      if (value.isSuccess()) {
        _clockStatus = value.getSuccess();
      } else {
        _clockStatus = null;
      }
      notifyListeners();
    });
  }

  void loadQuote() {
    getQuote(_accessToken ?? "").then((value) {
      if (value.isSuccess()) {
        _quote = value.getSuccess();
      } else {
        _quote = null;
      }
      notifyListeners();
    });
  }

  void login(String token) {
    _accessToken = token;
    loadUser();
    notifyListeners();
  }

  void logout() {
    _accessToken = '';
    _user = null;
    _quote = null;
    _clockStatus = null;
    notifyListeners();
  }
}
