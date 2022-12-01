import 'package:attendance_flutter/api/absent_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/record.dart';

class AbsentHistoryScreen extends StatefulWidget {
  const AbsentHistoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AbsentHistoryScreen();
}

class _AbsentHistoryScreen extends State<AbsentHistoryScreen> {
  List<Record> items = [];
  String jwt = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      jwt = prefs.getString("access_token") ?? "";
      loadAbsentHistory();
    });
  }

  void loadAbsentHistory() {
    setState(() {
      isLoading = true;
    });
    getAbsentHistory(jwt).then((value) {
      if (value.isSuccess()) {
        setState(() {
          items = value.getSuccess() ?? [];
        });
      } else {}
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Izin',
          style: GoogleFonts.inter(),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                String leaveStatus = 'Menunggu Konfirmasi';
                if ((items[index].leave?.leaveStatus ?? "") == "ACCEPT") {
                  leaveStatus = 'Izin Diterima';
                }

                if ((items[index].leave?.leaveStatus ?? "") == "REJECT") {
                  leaveStatus = 'Izin Ditolak';
                }

                return InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              items[index].leave?.type == 'SICK'
                                  ? 'Sakit'
                                  : 'Izin',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff17233D)),
                            ),
                            Text(
                              items[index].date ?? "",
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff515A6E)),
                            ),
                          ],
                        ),
                        Text(
                          leaveStatus,
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff808695)),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
