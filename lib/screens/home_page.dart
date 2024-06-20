import 'package:flutter/material.dart';
import 'package:pettopia/global_session.dart';
import 'package:pettopia/screens/beranda_page.dart';
import 'package:pettopia/screens/settings_page.dart';
import 'package:pettopia/pages/Daftar.dart';
import 'package:pettopia/pages/Masuk.dart';
import 'package:pettopia/screens/produk_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.tabIndex, required this.title})
      : super(key: key);

  final String title;
  final int tabIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  TextEditingController _searchController = TextEditingController();
  static List<Widget> _widgetOptions = <Widget>[
    BerandaPage(searchKeyword: ''),
    SizedBox.shrink(),
  ];

  bool _showAppBar = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showAppBar = index != 1;
      Navigator.pop(context); 
    });
  }

  void _showLoginRequiredPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Diperlukan"),
          content: Text("Silahkan login terlebih dahulu..."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showAppBar
          ? AppBar(
              backgroundColor: Colors.orange,
              elevation: 0, // Remove elevation for a flatter design
              title: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0), // Rounded border
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            // Update searchKeyword in BerandaPage
                            _widgetOptions[0] = BerandaPage(searchKeyword: value);
                          });
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Cari...',
                          border: InputBorder.none, // Remove TextField border
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Navigasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  if (!GlobalSession.islogin!) ...[
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                            child: Text('Masuk', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterPage()),
                              );
                            },
                            child: Text('Daftar', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Beranda'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('Pesanan Saya'),
              onTap: () {
                if (!GlobalSession.islogin!) {
                  _showLoginRequiredPopup(context);
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan Akun'),
              onTap: () {
                if (!GlobalSession.islogin!) {
                  _showLoginRequiredPopup(context);
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
