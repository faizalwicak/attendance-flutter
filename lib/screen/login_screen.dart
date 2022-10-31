import 'package:attendance_flutter/constant/color_constant.dart';
import 'package:attendance_flutter/constant/style_constant.dart';
import 'package:attendance_flutter/util/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/login_service.dart';
import '../notifier/auth_notifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarySwatch[200],
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Selamat Datang!",
                          style: TextStyle(
                            fontSize: 20,
                            color: titleTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Masuk untuk melanjutkan!",
                          style: TextStyle(
                            fontSize: 14,
                            color: subtitleTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Username',
                        style: labelTextStyle,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        keyboardType: TextInputType.name,
                        controller: _usernameController,
                        style: inputTextStyle,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Color(0xffe2e5e8),
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Password',
                        style: labelTextStyle,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        keyboardType: TextInputType.name,
                        controller: _passwordController,
                        style: inputTextStyle,
                        obscureText: true,
                        obscuringCharacter: '●',
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Color(0xffe2e5e8),
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () {
                                actoinLogin();
                              },
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Masuk'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void actoinLogin() {
    setState(() {
      _isLoading = true;
    });
    login(
      _usernameController.text,
      _passwordController.text,
    ).then((result) {
      if (result.isSuccess()) {
        Provider.of<AuthNotifier>(
          context,
          listen: false,
        ).login(result.getSuccess() ?? "");
      } else {
        displayMessageDialog(
          context,
          result.getError().toString(),
        );
      }
      setState(() {
        _isLoading = false;
      });
    });
  }
}
