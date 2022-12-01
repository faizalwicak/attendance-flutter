
import 'dart:convert';

import 'package:multiple_result/multiple_result.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../model/quote.dart';

Future<Result<String, Quote?>> getQuote(String jwt) async {
  try {
    final uri = Uri.parse('$baseUrl/quote');
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Success(Quote.fromJson(data));
    } else {
      return Error(response.reasonPhrase.toString());
    }
  } catch (e) {
    print(e);
    return const Error('Kesalahan Jaringan');
  }
}

