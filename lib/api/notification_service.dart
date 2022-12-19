import 'dart:convert';

import 'package:attendance_flutter/model/notification.dart';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:flutter/foundation.dart';

import '../constants.dart';

Future<Result<String, List<MNotification>>> getNotifications(String jwt) async {
  try {
    final uri = Uri.parse('$baseApiUrl/notification');
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    ).timeout(httpTimeout);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<MNotification> notificationArr = [];
      for (var i in data) {
        notificationArr.add(MNotification.fromJson(i));
      }
      return Success(notificationArr);
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
