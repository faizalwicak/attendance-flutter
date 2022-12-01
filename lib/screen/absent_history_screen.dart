import 'package:attendance_flutter/api/absent_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  String httpError = "";

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
      httpError = "";
    });
    getAbsentHistory(jwt).then((value) {
      if (value.isSuccess()) {
        setState(() {
          items = value.getSuccess() ?? [];
        });
      } else {
        setState(() {
          httpError = value.getError() ?? "";
          print(httpError);
        });
      }
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
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : (httpError != ""
              ? Center(
                  child: Text(
                    httpError,
                    style: GoogleFonts.inter(),
                  ),
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
                            bottom:
                                BorderSide(color: Colors.grey[300]!, width: 1),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff17233D)),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  items[index].date != null
                                      ? DateFormat("dd-MM-yyyy").format(
                                          DateTime.parse(items[index]!.date!))
                                      : "-",
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
                )),
    );
  }
}
