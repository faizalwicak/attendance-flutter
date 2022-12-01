
import 'dart:convert';

import 'package:attendance_flutter/model/record_friend.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../model/quote.dart';

Future<Result<String, List<RecordFriend>>> getRecordFriend(String jwt) async {
  try {
    final uri = Uri.parse('$baseUrl/record-friend');
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<RecordFriend> recordFriendArr = [];
      for (var i in data) {
        recordFriendArr.add(RecordFriend.fromJson(i));
      }
      return Success(recordFriendArr);
    } else {
      return Error(response.reasonPhrase.toString());
    }
  } catch (e) {
    print(e);
    return const Error('Kesalahan Jaringan');
  }
}

