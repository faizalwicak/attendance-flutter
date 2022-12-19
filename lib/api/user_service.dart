import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:flutter/foundation.dart';

import '../constants.dart';
import '../model/user.dart';

Future<Result<String, User>> getUserProfile(String jwt) async {
  try {
    final uri = Uri.parse('$baseApiUrl/profile');
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    ).timeout(httpTimeout);
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
    if (kDebugMode) {
      return Error(e.toString());
    }
    return const Error('Kesalahan Jaringan');
  }
}

Future<Result<String, String>> changePassword(String jwt, String oldPassword,
    String newPassword, String rePassword) async {
  try {
    final uri = Uri.parse('$baseApiUrl/password');
    final response = await http.post(
      uri,
      body: {
        'old-password': oldPassword,
        'password': newPassword,
        're-password': rePassword
      },
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $jwt'},
    ).timeout(httpTimeout);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Success(data['message']);
    } else if (response.statusCode == 422) {
      final data = json.decode(response.body);
      return Error(data['message']);
    } else if (response.statusCode == 401) {
      return const Error('401');
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

Future<Result<String, String>> changeProfilePicture(
    String jwt, String imagePath) async {
  try {
    final uri = Uri.parse('$baseApiUrl/profile-image');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    final responseStream = await request.send().timeout(httpTimeout);
    final response = await http.Response.fromStream(responseStream);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Success(data['message']);
    } else if (response.statusCode == 422) {
      final data = json.decode(response.body);
      return Error(data['message']);
    } else if (response.statusCode == 401) {
      return const Error('401');
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
