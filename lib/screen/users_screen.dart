import 'package:attendance_flutter/api/record_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/record_friend.dart';

AppBar usersAppBar = AppBar(
  title: const Text('Teman Kelas'),
  centerTitle: true,
  elevation: 0,
);

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UsersScreen();
}

class _UsersScreen extends State<UsersScreen> {
  List<RecordFriend> items = [];
  String jwt = "";
  bool isLoading = false;
  var httpError = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      jwt = prefs.getString('access_token') ?? "";
      loadRecordFriend();
    });
  }

  void loadRecordFriend() {
    setState(() {
      isLoading = true;
    });
    getRecordFriend(jwt).then((response) {
      if (response.isSuccess()) {
        items = response.getSuccess() ?? [];
      } else {
        httpError = response.getError() ?? "";
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (httpError != "") {
      return Center(child: Text(httpError));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var status = '';
        if ((items[index].records ?? []).isEmpty) {
          status = 'Belum Hadir';
        } else if (items[index].records?[0]?.leave != null) {
          status = items[index].records![0]!.leave!.type == "SICK"
              ? "Sakit"
              : "Izin";
        } else {
          status = 'Hadir';
        }
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[index].name ?? "",
                          style: GoogleFonts.inter(fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          items[index].username ?? "",
                          style: GoogleFonts.inter(fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    status,
                    style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[200],
              height: 1,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ],
        );
      },
    );
  }
}
