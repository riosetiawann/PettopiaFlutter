import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pettopia/global_session.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        "https://masmaroon.my.id/api/listbelanja.php?user_id=${GlobalSession.userid}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        products = responseData.map((item) => Product.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Pesanan Saya'),
      ),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () {
                      _showDeleteConfirmation(context, products[index].name);
                    },
                    leading: Image.network(
                      products[index].imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(products[index].name),
                    subtitle: Text(
                        '${products[index].quantity} x ${products[index].price} = Rp${products[index].subtotal}'),
                  ),
                );
              },
            ),
    );
  }
}

class Product {
  final String imageUrl;
  final String name;
  final int quantity;
  final double price;
  final double subtotal;

  Product({
    required this.imageUrl,
    required this.name,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      imageUrl: json['gambar'] ?? '',
      name: json['nama_hewan'] ?? '',
      quantity: json['jumlah'] ?? 0,
      price: double.parse(json['harga'].toString()),
      subtotal: double.parse(json['harga'].toString()) *
          double.parse(json['jumlah'].toString()),
    );
  }
}

Future<void> _showDeleteConfirmation(BuildContext context, String p) async {
  bool? result = await showConfirmationDialog(context, p);

  if (result == true) {
    // Logika penghapusan item di sini
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${p} dihapus'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${p} tidak dihapus'),
      ),
    );
  }
}

Future<bool?> showConfirmationDialog(BuildContext context, String psn) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Konfirmasi'),
        content: Text('Apakah Anda yakin ingin menghapus ${psn}?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Tidak
            },
            child: Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Ya
            },
            child: Text('Ya'),
          ),
        ],
      );
    },
  );
}
