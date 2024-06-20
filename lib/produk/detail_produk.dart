import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pettopia/global_session.dart';
import 'package:pettopia/screens/produk_list.dart';

class DetailProduk extends StatefulWidget {
  final Map<String, dynamic> product;

  DetailProduk({required this.product});

  @override
  _DetailProdukState createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  int quantity = 1; // Initial quantity
  bool _isLoading = false;

  Future<void> _simpanTransaksi(int hewanid, int jumlah, String harga) async {
    if (!GlobalSession.islogin!) {
      _showLoginPopup();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://masmaroon.my.id/api/transaksibaru.php');
    final data = {
      'user_id': GlobalSession.userid,
      'hewan_id': hewanid.toString(),
      'jumlah': jumlah.toString(),
      'harga': harga,
    };

    try {
      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
          ),
        );

        // Delay for 1 second before navigating to ensure SnackBar is visible
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ProductListPage(),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: ${response.statusCode}'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showLoginPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notifikasi"),
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.product['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rp' + widget.product['price'].toString().split(".")[0],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.product['title'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[300],
                  ), // Garis pemisah
                  SizedBox(height: 16),
                  Text(
                    'Deskripsi Produk:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.product['deskripsi'],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blue, // Warna kiri
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 60.0, // Atur ketinggian bottomNavigationBar
                decoration: BoxDecoration(
                  color: Colors.orange, // Warna kiri
                ),
                child: TextButton(
                  onPressed: () {
                    if (!GlobalSession.islogin!) {
                      _showLoginPopup();
                      return;
                    }

                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        double screenWidth =
                            MediaQuery.of(context).size.width;

                        return StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setState) {
                            return IntrinsicHeight(
                              child: SingleChildScrollView(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 20.0, 20.0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Image.network(
                                              widget.product['image'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(width: 20.0),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Rp${widget.product['price'].toString().split(".")[0]}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Stok: ${widget.product['stock']}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: Colors.grey[300],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Jumlah',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                              width:
                                                  10), // Menambah jarak antara teks "Jumlah" dan kotak border
                                          Expanded(
                                            child: Align(
                                              alignment:
                                                  Alignment.centerRight,
                                              child: Container(
                                                width:
                                                    120.0, // Lebar kotak border
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.2,
                                                  ), // Mengurangi ukuran border
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconButton(
                                                      iconSize:
                                                          16, // Perkecil ukuran tombol
                                                      icon: Icon(Icons.remove),
                                                      onPressed: () {
                                                        setState(() {
                                                          if (quantity > 1) {
                                                            quantity--;
                                                          }
                                                        });
                                                      },
                                                    ),
                                                    Text(
                                                      '$quantity',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      iconSize:
                                                          16, // Perkecil ukuran tombol
                                                      icon: Icon(Icons.add),
                                                      onPressed: () {
                                                        setState(() {
                                                          quantity++;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.0),
                                      Container(
                                        width: screenWidth - 40.0,
                                        child: Card(
                                          color: Colors.orange,
                                          shadowColor: Colors.transparent,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: GestureDetector(
                                            onTap: _isLoading
                                                ? null
                                                : () {
                                                    Navigator.pop(
                                                        context); // Tutup tampilan popup
                                                    _simpanTransaksi(
                                                      widget.product['id'],
                                                      quantity,
                                                      widget.product['price']
                                                          .toString(),
                                                    );
                                                  },
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Beli Sekarang',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Text(
                    'Beli Sekarang',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
