import 'dart:convert';

import 'package:multiple_result/multiple_result.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

Future<Result<String, String>> login(String username, String password) async {
  try {
    final uri = Uri.parse('$baseUrl/login');
    final response = await http.post(
      uri,
      body: {'username': username, 'password': password},
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access_token']);
      return Success(data['access_token']);
    } else if (response.statusCode == 422) {
      final data = json.decode(response.body);
      return Error(data['message']);
    } else {
      return Error(response.reasonPhrase.toString());
    }
  } catch (e) {
    return const Error('Kesalahan Jaringan');
  }
}
