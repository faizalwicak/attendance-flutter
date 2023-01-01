import 'package:attendance_flutter/constant/color_constant.dart';
import 'package:attendance_flutter/screen/dashboard_screen.dart';
import 'package:attendance_flutter/screen/notification_screen.dart';
import 'package:attendance_flutter/screen/profile_screen.dart';
import 'package:attendance_flutter/screen/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../notifier/auth_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: primarySwatch[500],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SvgPicture.asset('assets/images/icon_category.svg'),
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SvgPicture.asset('assets/images/icon_clipboard.svg'),
            ),
            label: 'Teman',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 5,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/icon_message_notif.svg',
                  ),
                ),
                Consumer<AuthNotifier>(builder: (context, notifier, child) {
                  if ((notifier.user?.notifications ?? 0) == 0) {
                    return const SizedBox(
                      width: 0,
                      height: 0,
                    );
                  }
                  return Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        notifier.user?.notifications?.toString() ?? "0",
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }),
              ],
            ),
            label: 'Pengumuman',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SvgPicture.asset('assets/images/icon_profile.svg'),
            ),
            label: 'Akun',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        unselectedLabelStyle: GoogleFonts.inter(),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: primaryColor,
        selectedFontSize: 12,
        unselectedItemColor: bottomBarUnselectedColor,
        type: BottomNavigationBarType.fixed,
      ),
      appBar: [
        null,
        usersAppBar,
        notificationAppBar,
        profileAppBar,
      ][_selectedIndex],
      body: [
        const DashboardScreen(),
        const UsersScreen(),
        const NotificationScreen(),
        const ProfileScreen(),
      ][_selectedIndex],
    );
  }
}
