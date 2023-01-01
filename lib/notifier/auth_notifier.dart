import 'dart:convert';

import 'package:attendance_flutter/api/clock_service.dart';
import 'package:attendance_flutter/util/shared_preference_helper.dart';
import 'package:flutter/material.dart';

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

  String _httpError = "";
  String get httpError => _httpError;

  AuthNotifier() {
    getStringPref(keyAccessToken).then((value) {
      _accessToken = value;
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
    _httpError = "";
    getUserProfile(_accessToken ?? "").then((value) {
      if (value.isSuccess()) {
        _user = value.getSuccess();
        setStringPref(keyUser, json.encode(_user?.toJson()));
        loadClockStatus();
      } else if (value.getError() == '401') {
        logout();
      } else {
        _httpError = value.getError() ?? "";
        getStringPref(keyUser).then((value) {
          _user = User.fromJson(json.decode(value));
        });
      }
      notifyListeners();
    });
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

  void login(String token) {
    _accessToken = token;
    loadUser();
    notifyListeners();
  }

  void logout() {
    clearPref().then((value) {
      _accessToken = '';
      _user = null;
      _clockStatus = null;
      notifyListeners();
    });
  }
}
