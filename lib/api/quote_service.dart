import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:flutter/foundation.dart';
import '../constants.dart';
import '../model/quote.dart';

Future<Result<String, Quote?>> getQuote(String jwt) async {
  try {
    final uri = Uri.parse('$baseApiUrl/quote');
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    ).timeout(httpTimeout);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Success(Quote.fromJson(data));
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
