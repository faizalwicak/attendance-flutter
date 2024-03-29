import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../constants.dart';
import '../model/message.dart';

Future<Result<String, String>> login(
    String username, String password, String deviceId) async {
  try {
    final uri = Uri.parse('$baseApiUrl/login');
    final response = await http.post(
      uri,
      body: {'username': username, 'password': password, 'device_id': deviceId},
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Accept': 'application/json'
      },
    ).timeout(httpTimeout);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access_token']);
      return Success(data['access_token']);
    } else if (response.statusCode == 422) {
      final data = json.decode(response.body);
      final message = Message.fromJson(data);
      return Error(message.message ?? "");
    } else {
      return Error(response.reasonPhrase.toString());
    }
  } catch (e) {
    if (kDebugMode) {
      return Error(e.toString());
    }

    return const Error('Kesalahan Jaringan');
  }
}
