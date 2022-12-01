import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';

import '../constants.dart';
import '../model/message.dart';
import '../model/record.dart';

const clockInType = "clock-in";
const clockOutType = "clock-out";

Future<Result<String, String>> clockNow(
    String jwt, String clockType, double lat, double lng) async {
  try {
    final uri = Uri.parse('$baseApiUrl/$clockType');
    final response = await http.post(
      uri,
      body: {
        "lat": lat.toString(),
        "lng": lng.toString(),
        // "type": clockType,
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

Future<Result<String, Record?>> getClockStatus(String jwt) async {
  try {
    final uri = Uri.parse('$baseApiUrl/clock-status');
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Success(Record.fromJson(data));
    } else {
      return Error(response.reasonPhrase.toString());
    }
  } catch (e) {
    print(e);
    return const Error('Kesalahan Jaringan');
  }
}

Future<Result<String, List<Record?>>> getClockHistory(
    String jwt, int year, int month) async {
  try {
    String params = "?year=$year&month=$month";
    final uri = Uri.parse('$baseApiUrl/clock-history$params');
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Record?> responseArray = [];
      for (var i in data) {
        if (i != null) {
          responseArray.add(Record.fromJson(i));
        } else {
          responseArray.add(null);
        }
      }
      return Success(responseArray);
    } else {
      return Error(response.reasonPhrase.toString());
    }
  } catch (e) {
    print(e);
    return const Error('Kesalahan Jaringan');
  }
}
