import 'dart:io';

import 'package:attendance_flutter/constant/color_constant.dart';
import 'package:attendance_flutter/screen/home_screen.dart';
import 'package:attendance_flutter/screen/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

import 'notifier/auth_notifier.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
      ],
      child: FlutterWebFrame(
        builder: (context) {
          return MaterialApp(
            title: 'Attendance Flutter',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: createMaterialColor(primaryColor),
            ),
            localizationsDelegates: const [
              MonthYearPickerLocalizations.delegate,
            ],
            home: Consumer<AuthNotifier>(
              builder: (context, value, child) {
                if (value.accessToken == null) {
                  return const Scaffold(
                    backgroundColor: backgroundColor,
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (value.accessToken == '') {
                  return const LoginScreen();
                }
                return const HomeScreen();
              },
            ),
          );
        },
        maximumSize: const Size(475, 812),
        enabled: kIsWeb,
      ),
    );
  }
}
