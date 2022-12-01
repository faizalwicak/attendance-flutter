import 'package:attendance_flutter/api/user_service.dart';
import 'package:attendance_flutter/constant/style_constant.dart';
import 'package:attendance_flutter/screen/password_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../notifier/auth_notifier.dart';
import '../util/dialog_helper.dart';
import '../util/string_helper.dart';

AppBar profileAppBar = AppBar(
  title: const Text('Profil'),
  centerTitle: true,
  elevation: 0,
);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  bool _isLoading = false;
  String _jwt = "";

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      _jwt = prefs.getString('access_token') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, value, child) {
        return ListView(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: 100,
              height: 100,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : (value.user?.image != null
                      ? Center(
                          child: ClipOval(
                            child: Image.network(
                              '$baseUrl/images/${value.user?.image}',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, exception, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: const Color(0xFF35415A),
                                  alignment: Alignment.center,
                                  child: Text(
                                    getInitials(value.user?.name ?? ""),
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 32,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: const Color(0xFF35415A),
                          child: Text(
                            getInitials(value.user?.name ?? ""),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 32,
                            ),
                          ),
                        )),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    final ImagePicker picker = ImagePicker();
                    picker.pickImage(source: ImageSource.gallery).then((image) {
                      if (image != null) {
                        setState(() {
                          _isLoading = true;
                        });
                        changeProfilePicture(_jwt, image.path).then((res) {
                          if (res.isSuccess()) {
                            displayMessageDialog(
                              context,
                              res.getSuccess() ?? "",
                            );
                            Provider.of<AuthNotifier>(context, listen: false)
                                .freshLoadUser();
                          } else {
                            displayMessageDialog(
                              context,
                              res.getError() ?? "",
                            );
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        });
                      }
                    });
                  },
                  child: Text(
                    'Ganti Foto',
                    style: GoogleFonts.inter(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              value.user?.name ?? "",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value.user?.username ?? "",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xff515A6E),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sekolah',
                    style: labelTextStyle,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    style: inputTextStyle,
                    enabled: false,
                    decoration: inputDecoration,
                    initialValue: value.user?.school?.name ?? "",
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Kelas',
                    style: labelTextStyle,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    style: inputTextStyle,
                    enabled: false,
                    decoration: inputDecoration,
                    initialValue: value.user?.grade?.name ?? "",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6))),
                child: const Text('Ganti Password'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordScreen()));
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'Keluar',
                  style: GoogleFonts.inter(color: Colors.red),
                ),
                onPressed: () {
                  displayConfirmDialog(
                    context: context,
                    text: 'Apakah anda yakin akan keluar?',
                    okTitle: 'KELUAR',
                    callback: () {
                      logout().then((_) {
                        Provider.of<AuthNotifier>(context, listen: false)
                            .logout();
                      });
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
  }
}
