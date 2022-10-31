import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';

import '../constants.dart';
import '../model/user.dart';

Future<Result<String, User>> getUserProfile(String jwt) async {
  try {
    final uri = Uri.parse('$baseUrl/profile');
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Success(User.fromJson(data));
    } else if (response.statusCode == 422) {
      final data = json.decode(response.body);
      return Error(data['message']);
    } else if (response.statusCode == 401) {
      return const Error('401');
    } else {
      return Error(response.reasonPhrase.toString());
    }
  } catch (e) {
    return const Error('Kesalahan Jaringan');
  }
}
