import 'package:shared_preferences/shared_preferences.dart';

const keyAccessToken = "access_token";
const keyUser = 'user';
const keyClockStatus = 'clock_status';
const keyQuote = 'quote';

Future<String> getStringPref(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? "";
}

Future<void> setStringPref(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<void> clearPref() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
