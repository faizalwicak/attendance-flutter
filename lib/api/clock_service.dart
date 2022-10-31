import 'dart:convert';

import 'package:attendance_flutter/model/message.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

const clockInType = "CLOCK_IN";
const clockOutType = "CLOCK_OUT";

Future<Result<String, String>> clockNow(
    String jwt, String clockType, double lat, double lng) async {
  try {
    final uri = Uri.parse('$baseUrl/clock');
    final response = await http.post(
      uri,
      body: {
        "lat": lat.toString(),
        "lng": lng.toString(),
        "type": clockType,
      },
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final message = Message.fromJson(data);
      return Success(message.message ?? "");
    } else if (response.statusCode == 422) {
      final data = json.decode(response.body);
      final message = Message.fromJson(data);
      return Error(message.message ?? "");
    } else {
      return Error(response.reasonPhrase.toString());
    }
  } catch (e) {
    return const Error('Kesalahan Jaringan');
  }
}
