import 'dart:io';

import 'package:attendance_flutter/constant/style_constant.dart';
import 'package:attendance_flutter/util/dialog_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  String deviceId = "";

  @override
  void initState() {
    super.initState();

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if (kIsWeb) {
      deviceInfoPlugin.webBrowserInfo.then((info) {
        deviceId = info.vendor.toString() +
            info.userAgent.toString() +
            info.hardwareConcurrency.toString();
      });
    } else if (Platform.isAndroid) {
      deviceInfoPlugin.androidInfo.then((info) {
        setState(() {
          deviceId = info.id;
        });
      });
    } else if (Platform.isIOS) {
      deviceInfoPlugin.iosInfo.then((info) {
        setState(() {
          deviceId = info.identifierForVendor ?? "";
        });
      });
    }
  }

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F4),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    child: Image.asset('assets/images/image_login_1.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DIGITAL ABSENSI',
                          style: GoogleFonts.inter(
                            color: const Color(0xff336BB0),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'SMAN 1 SLEMAN',
                          style: GoogleFonts.inter(
                            color: const Color(0xff336BB0),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Log in',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Username',
                    style: labelTextStyle,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.name,
                    controller: _usernameController,
                    style: inputTextStyle,
                    decoration: inputDecoration,
                  ),
                  const SizedBox(height: 20),
                  Text(
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
                    decoration: inputDecoration,
                  ),
                  const SizedBox(height: 20),
                  roundElevatedButton(
                    title: 'Masuk',
                    isLoading: _isLoading,
                    onClick: () {
                      // final deviceInfoPlugin = DeviceInfoPlugin();
                      // if (Platform.isAndroid) {}
                      actionLogin();
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void actionLogin() {
    setState(() {
      _isLoading = true;
    });
    login(
      _usernameController.text,
      _passwordController.text,
      deviceId,
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
