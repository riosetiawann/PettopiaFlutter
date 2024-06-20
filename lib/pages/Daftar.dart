import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Daftar'),
      ),
      body: RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _namalengkapController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _notelponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
              height: 100,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _confirmpasswordController,
              decoration: InputDecoration(
                labelText: 'Ulangi password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _namalengkapController,
              decoration: InputDecoration(
                labelText: 'Nama lengkap',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(
                labelText: 'Alamat',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _notelponController,
              decoration: InputDecoration(
                labelText: 'HP/WA',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _registerUser(); // Panggil fungsi _registerUser saat tombol ditekan
              },
              child: Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }

  void _registerUser() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String namalengkap = _namalengkapController.text.trim();
    String alamat = _alamatController.text.trim();
    String notelepon = _notelponController.text.trim();
    String password = _passwordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        namalengkap.isEmpty ||
        notelepon.isEmpty ||
        alamat.isEmpty) {
      // Validasi jika ada field yang kosong
      // Tampilkan pesan kesalahan atau validasi di sini jika perlu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lengkapi kolom isian terlebih dahulu...'),
        ),
      );
      return;
    }

    String pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Format email tidak valid, silahkan cek lagi...'),
        ),
      );
      return;
    }

    if (_confirmpasswordController.text.trim() !=
        _passwordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Konfirmasi password tidak sama, silahkan cek lagi...'),
        ),
      );
      return;
    }

    // Mengirim data ke URL dengan metode POST
    final response = await http.post(
      Uri.parse('https://masmaroon.my.id/api/registeruser.php'),
      body: {
        'username': username,
        'email': email,
        'password': password,
        'nama_lengkap': namalengkap,
        'alamat': alamat,
        'no_telepon': notelepon,
      },
    );

    // Mengecek status respon dari server
    if (response.statusCode == 200) {
      // Mendekode respon JSON

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(json.decode(response.body)['message']),
        ),
      );

      Map<String, dynamic> data = json.decode(response.body);

      // Menampilkan pesan dari respon server
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Pesan'),
            content: Text(data['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Menampilkan pesan kesalahan jika terjadi masalah dengan koneksi atau server
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Gagal terhubung ke server.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
