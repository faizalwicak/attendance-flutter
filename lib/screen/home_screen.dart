import 'package:attendance_flutter/constant/color_constant.dart';
import 'package:attendance_flutter/screen/dashboard_screen.dart';
import 'package:attendance_flutter/screen/notification_screen.dart';
import 'package:attendance_flutter/screen/profile_screen.dart';
import 'package:attendance_flutter/screen/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
              padding: EdgeInsets.symmetric(vertical: 5),
              child: SvgPicture.asset('assets/images/icon_category.svg'),
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: SvgPicture.asset('assets/images/icon_clipboard.svg'),
            ),
            label: 'Teman',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: SvgPicture.asset('assets/images/icon_message_notif.svg'),
            ),
            label: 'Pengumuman',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
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
