import 'package:attendance_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/clock_service.dart';
import '../model/record.dart';

class ClockHistoryScreen extends StatefulWidget {
  const ClockHistoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ClockHistoryScreen();
}

class _ClockHistoryScreen extends State<ClockHistoryScreen> {
  List<Record?> recordList = [];
  String jwt = "";
  DateTime date = DateTime.now();
  bool isLoading = true;
  String httpError = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      jwt = prefs.getString('access_token') ?? "";
      loadClockHistory();
    });
  }

  void loadClockHistory() {
    setState(() {
      isLoading = true;
    });
    getClockHistory(jwt, date.year, date.month).then((value) {
      if (value.isSuccess()) {
        setState(() {
          recordList = value.getSuccess()!;
        });
      } else {
        recordList = [];
        setState(() {
          httpError = value.getError() ?? "";
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
        elevation: 0,
        title: Text(
          'Riwayat Presensi',
          style: GoogleFonts.inter(),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            height: 50,
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${monthName[date.month - 1]} ${date.year}',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                ),
                OutlinedButton(
                  onPressed: () {
                    showMonthYearPicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2021),
                      lastDate: DateTime.now(),
                    ).then((value) {
                      if (value != null) {
                        date = value;
                        loadClockHistory();
                      }
                    });
                  },
                  child: Text(
                    'ganti',
                    style: GoogleFonts.inter(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : httpError != ""
                    ? Center(
                        child: Text(
                          httpError,
                          style: GoogleFonts.inter(),
                        ),
                      )
                    : Container(
                        color: Colors.white,
                        child: ListView.builder(
                          itemCount: recordList.length,
                          // padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  color: const Color(0xffF8F8F9),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Expanded(child: Container()),
                                      Text(
                                        "${index + 1} ${monthName[date.month - 1]} ${date.year}",
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff515A6E)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Masuk',
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff17233D)),
                                      ),
                                      Expanded(child: Container()),
                                      Text(
                                        recordList[index]
                                                ?.attend
                                                ?.clockInTime ??
                                            "-",
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff808695)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.grey[200],
                                  height: 1,
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Pulang',
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff17233D)),
                                      ),
                                      Expanded(child: Container()),
                                      Text(
                                        recordList[index]
                                                ?.attend
                                                ?.clockInTime ??
                                            "-",
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff808695)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
