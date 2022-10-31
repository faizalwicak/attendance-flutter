import 'package:attendance_flutter/api/clock_service.dart';
import 'package:attendance_flutter/constant/color_constant.dart';
import 'package:attendance_flutter/util/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notifier/auth_notifier.dart';
import 'location_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarySwatch[500],
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                color: primarySwatch[500],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Selamat datang !",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.account_circle,
                                size: 60,
                                color: primarySwatch[200],
                              ),
                              const SizedBox(width: 20),
                              Consumer<AuthNotifier>(
                                  builder: (context, notifier, child) {
                                if (notifier.user == null) {
                                  return const Text("Loading . . .");
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notifier.user!.name ?? ". . .",
                                      style: const TextStyle(
                                        color: inputTextColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      notifier.user!.grade?.name ?? ". . .",
                                      style: const TextStyle(
                                        color: inputTextColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      notifier.user!.school?.name ?? ". . .",
                                      style: const TextStyle(
                                        color: inputTextColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  color: primaryColor,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_box_outline_blank_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Absen Masuk',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Text(
                                'Anda belum melakukan absen masuk.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LocationScreen(clockInType),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  color: Colors.red[500],
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_box_outline_blank_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Absen Pulang',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Text(
                                'Anda belum melakukan absen pulang.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LocationScreen(clockOutType),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: ElevatedButton(
                  child: const Text('KELUAR'),
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
          ),
        ),
      ),
    );
  }

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
  }
}
