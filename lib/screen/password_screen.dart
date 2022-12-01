import 'dart:async';

import 'package:attendance_flutter/api/user_service.dart';
import 'package:attendance_flutter/util/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/style_constant.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PasswordScreen();
}

class _PasswordScreen extends State<PasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  var _isLoadingSubmit = false;
  String jwt = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      jwt = prefs.getString("access_token") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Ganti Password',
          style: GoogleFonts.inter(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),
          Text(
            'Password lama',
            style: labelTextStyle,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: inputTextStyle,
            decoration: inputDecoration,
            obscureText: true,
            obscuringCharacter: '●',
            controller: _oldPasswordController,
          ),
          const SizedBox(height: 10),
          Text(
            'Password Baru',
            style: labelTextStyle,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: inputTextStyle,
            decoration: inputDecoration,
            obscureText: true,
            obscuringCharacter: '●',
            controller: _passwordController,
          ),
          const SizedBox(height: 10),
          Text(
            'Konnfirmasi Password Baru',
            style: labelTextStyle,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: inputTextStyle,
            decoration: inputDecoration,
            obscureText: true,
            obscuringCharacter: '●',
            controller: _rePasswordController,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: _isLoadingSubmit
                ? null
                : () {
                    setState(() {
                      _isLoadingSubmit = true;
                    });
                    changePassword(
                      jwt,
                      _oldPasswordController.text,
                      _passwordController.text,
                      _rePasswordController.text,
                    ).then((value) {
                      if (value.isSuccess()) {
                        displayMessageDialog(
                          context,
                          value.getSuccess().toString(),
                          () {
                            Navigator.pop(context);
                            _oldPasswordController.text = "";
                            _passwordController.text = "";
                            _rePasswordController.text = "";
                          },
                        );
                      } else {
                        displayMessageDialog(
                          context,
                          value.getError().toString(),
                        );
                      }
                      setState(() {
                        _isLoadingSubmit = false;
                      });
                    });
                  },
            child: _isLoadingSubmit
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    'Simpan',
                    style: GoogleFonts.inter(),
                  ),
          ),
        ],
      ),
    );
  }
}
