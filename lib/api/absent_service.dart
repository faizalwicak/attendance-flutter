
import 'dart:convert';

import 'package:multiple_result/multiple_result.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../model/absent.dart';
import '../model/message.dart';
import '../model/record.dart';

Future<Result<String, String>> addAbsent(
    String jwt, String absentType, String description, String date) async {
  try {
    final uri = Uri.parse('$baseUrl/leave');
    final response = await http.post(
      uri,
      body: {
        "type": absentType,
        "date": date,
        "description": description
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

Future<Result<String, List<Record>>> getAbsentHistory(String jwt) async {
  try {
    final uri = Uri.parse('$baseUrl/leave');
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    );
    if (response.statusCode == 200) {
      List<Record> absentList = [];
      final data = json.decode(response.body);
      for (var i in data) {
        absentList.add(Record.fromJson(i));
      }
      return Success(absentList);
    } else {
      return Error(response.reasonPhrase.toString());
    }
  } catch (e) {
    print(e);
    return const Error('Kesalahan Jaringan');
  }
}