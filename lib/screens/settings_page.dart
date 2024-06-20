import 'package:flutter/material.dart';
import 'package:pettopia/global_session.dart';
import 'package:pettopia/screens/home_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Pengaturan Akun'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.0),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: OutlinedButton(
              onPressed: () {
                GlobalSession.islogin = false;
                GlobalSession.userid = "";
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Kamu telah keluar dari sesi aplikasi"),
                  ),
                );
                Navigator.of(context).pop(
                  MaterialPageRoute(
                    builder: (_) => const HomePage(tabIndex: 0, title: ""),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.orange),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
