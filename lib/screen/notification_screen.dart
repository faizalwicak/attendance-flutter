import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


AppBar notificationAppBar = AppBar(
  title: const Text('Pengumuman'),
  centerTitle: true,
  elevation: 0,
);

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (1==1) {
      return Center(child: Text('Belum ada notifikasi.', style: GoogleFonts.inter()),);
    }
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
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
                          'Budi Susanto',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '1235345',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ),
                  const Text('Sakit'),
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