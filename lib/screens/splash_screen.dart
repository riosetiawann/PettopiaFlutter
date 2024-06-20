import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pettopia/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pettopia',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const SplashScreen(), // Tampilkan SplashScreen sebagai halaman awal
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Tambahkan logika penundaan di sini sebelum pindah ke halaman berikutnya
    Timer(const Duration(seconds: 2), () {
      // Pindah ke halaman beranda setelah penundaan
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomePage(tabIndex: 0, title: ""),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.deepOrange, // Warna latar belakang SplashScreen menjadi oranye
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Tambahkan logo di sini
            Image.asset(
              'assets/logo.png', // Sesuaikan dengan path logo Anda
              width: 150, // Sesuaikan dengan lebar logo
              height: 150, // Sesuaikan dengan tinggi logo
            ),
          ],
        ),
      ),
    );
  }
}
