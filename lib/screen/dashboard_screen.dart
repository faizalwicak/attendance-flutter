import 'package:attendance_flutter/screen/absent_history_screen.dart';
import 'package:attendance_flutter/screen/absent_screen.dart';
import 'package:attendance_flutter/screen/clock_history_screen.dart';
import 'package:attendance_flutter/screen/leave_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../api/clock_service.dart';
import '../constant/color_constant.dart';
import '../notifier/auth_notifier.dart';
import 'location_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget cardItem(
          String title, Widget icon, Color backgroundColor, Function onClick) =>
      Expanded(
        child: InkWell(
          onTap: () {
            onClick.call();
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.rectangle, // : BoxShape.circle,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Column(
              children: [
                icon,
                const SizedBox(height: 10),
                Text(
                  title + '\n',
                  style: GoogleFonts.inter(
                    color: const Color(0xff808695),
                    fontSize: 10,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        Stack(
          children: [
            Container(
              color: primaryColor,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 100,
                        left: 20,
                        right: 20,
                        bottom: 40,
                      ),
                      child: Consumer<AuthNotifier>(
                        builder: (context, notifier, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                notifier.user?.school?.name ?? "memuat . . .",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                notifier.user?.name ?? "",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                notifier.user?.grade?.name ?? "",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 80),
                    width: 80,
                    height: 150,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Image.asset(
                            'assets/images/image_login_1.png',
                            height: 150,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/image_profile.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              cardItem(
                'Presensi',
                SvgPicture.asset(
                  'assets/images/icon_location_tick.svg',
                  height: 20,
                  width: 20,
                ),
                const Color.fromARGB(10, 51, 107, 176),
                () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LocationScreen(),
                  ));
                },
              ),
              const SizedBox(width: 20),
              cardItem(
                'Riwayat Presensi',
                SvgPicture.asset(
                  'assets/images/icon_note.svg',
                  height: 20,
                  width: 20,
                ),
                const Color.fromARGB(10, 176, 51, 169),
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ClockHistoryScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
              cardItem(
                'Buat Izin',
                SvgPicture.asset(
                  'assets/images/icon_calendar.svg',
                  height: 20,
                  width: 20,
                ),
                const Color.fromARGB(10, 176, 120, 51),
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AbsentScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
              cardItem(
                'Riwayat Izin',
                SvgPicture.asset(
                  'assets/images/icon_directbox_notif.svg',
                  height: 20,
                  width: 20,
                ),
                const Color.fromARGB(10, 51, 176, 57),
                () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AbsentHistoryScreen(),
                  ));
                },
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xffDCDEE2)),
            color: const Color(0xffF8F8F9),
          ),
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<AuthNotifier>(
                      builder: (context, notifier, child) {
                        if (notifier.quote != null) {
                          return Text(
                            notifier!.quote?.message ?? "",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }
                        return Text(
                          '-',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Image.asset('assets/images/image_quote.png'),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xffDCDEE2)),
            color: const Color(0xffF8F8F9),
          ),
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Keterangan', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),),
                    const SizedBox(
                      height: 10
                    ),
                    Consumer<AuthNotifier>(
                      builder: (context, notifier, child) {
                        var message = [];
                        if (notifier.clockStatus != null) {
                          if (notifier.clockStatus!.attend?.clockInTime != null) {
                            message.add("Anda sudah presensi masuk pada ${notifier.clockStatus!.attend!.clockInTime}");
                          }
                          if (notifier.clockStatus!.attend?.clockOutTime != null) {
                            message.add("Anda sudah presensi pulang pada ${notifier.clockStatus!.attend!.clockOutTime}");
                          }
                          if (message.length == 0) {
                            message.add("Anda belum presensi.");
                          }

                          return Text(
                            message.join("\n"),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }
                        return Text(
                          'Anda Belum presensi.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}