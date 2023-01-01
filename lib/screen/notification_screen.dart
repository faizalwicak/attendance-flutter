import 'package:attendance_flutter/api/notification_service.dart';
import 'package:attendance_flutter/model/notification.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notifier/auth_notifier.dart';

AppBar notificationAppBar = AppBar(
  title: const Text('Pengumuman'),
  centerTitle: true,
  elevation: 0,
);

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  List<MNotification> items = [];
  String jwt = "";
  bool isLoading = false;
  var httpError = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      jwt = prefs.getString('access_token') ?? "";
      loadNotifications();
    });
  }

  void loadNotifications() {
    setState(() {
      isLoading = true;
    });
    getNotifications(jwt).then((response) {
      if (response.isSuccess()) {
        items = response.getSuccess() ?? [];
        Provider.of<AuthNotifier>(context, listen: false).freshLoadUser();
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
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (items.isEmpty) {
      return Center(
        child: Text('Belum ada pengumuman.', style: GoogleFonts.inter()),
      );
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    items[index].title ?? "",
                    style: GoogleFonts.inter(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    items[index].message ?? "",
                    style: GoogleFonts.inter(fontWeight: FontWeight.w200),
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
