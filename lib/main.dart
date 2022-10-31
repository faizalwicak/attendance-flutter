import 'package:attendance_flutter/constant/color_constant.dart';
import 'package:attendance_flutter/screen/home_screen.dart';
import 'package:attendance_flutter/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifier/auth_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
      ],
      child: MaterialApp(
        title: 'Attendance Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: createMaterialColor(primaryColor),
        ),
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
      ),
    );
  }
}
