import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pettopia/global_session.dart';
import 'package:pettopia/screens/home_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Masuk'),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _cekLogin(String email, String password) async {
    final url = Uri.parse('https://masmaroon.my.id/api/ceklogin.php');
    final data = {'username': email, 'password': password};

    try {
      final response = await http.post(
        url,
        body: data,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Jika login berhasil
          GlobalSession.islogin = true;
          print("islog: " + GlobalSession.islogin.toString());
          GlobalSession.userid = responseData['user']['user_id'].toString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Berhasil masuk sebagai ${responseData['user']['nama_lengkap']}"),
            ),
          );
          Navigator.of(context).pop(
            MaterialPageRoute(
              builder: (_) => const HomePage(tabIndex: 0, title: ""),
            ),
          );
        } else {
          // Jika login gagal
          print('Login gagal: ${responseData['message']}');
        }
      } else {
        // Jika terjadi kesalahan saat mengirim permintaan
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Menangani error jika terjadi
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'assets/logo.png', // Ubah path sesuai dengan path logo Anda
                    height: 100,
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
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
                  ElevatedButton(
                    onPressed: () {
                      // Tambahkan logika autentikasi di sini
                      _cekLogin(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                    child: Text('Masuk'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
