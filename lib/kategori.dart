import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KategoriPage extends StatefulWidget {
  @override
  _KategoriPageState createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  List<Map<String, dynamic>> kategoriHewan = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('https://masmaroon.my.id/api/viewkategori.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        kategoriHewan = data.map((item) {
          return {
            'nama': item['nama_kategori'],
            'gambar': item['gambar'],
          };
        }).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil data...'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Kategori'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          childAspectRatio: 1.0,
        ),
        itemCount: kategoriHewan.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                // Tambahkan logika navigasi ke halaman terkait dengan kategori tertentu jika diperlukan
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.3,
                    child: Container(
                      margin: EdgeInsets.only(top: 8.0),
                      child: Image.network(
                        kategoriHewan[index]['gambar'],
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    kategoriHewan[index]['nama'],
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
