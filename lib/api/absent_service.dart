import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';

import '../constants.dart';
import '../model/message.dart';
import '../model/record.dart';

Future<Result<String, String>> addAbsent(
  String jwt,
  String absentType,
  String description,
  String date,
  String imagePath,
) async {
  try {
    final uri = Uri.parse('$baseApiUrl/leave');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));
    request.fields.addAll({
      "type": absentType,
      "date": date,
      "description": description,
    });

    final responseStream = await request.send().timeout(httpTimeout);
    final response = await http.Response.fromStream(responseStream);

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
    print(e);
    return const Error('Kesalahan Jaringan');
  }
}

Future<Result<String, List<Record>>> getAbsentHistory(String jwt) async {
  try {
    final uri = Uri.parse('$baseApiUrl/leave');
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    ).timeout(httpTimeout);
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
