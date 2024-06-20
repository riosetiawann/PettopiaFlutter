import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pettopia/kategori.dart';
import 'package:pettopia/produk/detail_produk.dart'; 

class BerandaPage extends StatefulWidget {
  final String searchKeyword; 

  const BerandaPage({Key? key, required this.searchKeyword}) : super(key: key);

  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = []; 

  late http.Client httpClient; 
  @override
  void initState() {
    super.initState();
    httpClient = http.Client();
    fetchProducts();
  }

  @override
  void dispose() {
   
    httpClient.close();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://masmaroon.my.id/api/viewhewan.php');
    final response = await httpClient.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        products = responseData.map((item) {
          return {
            'id': item['hewan_id'] ?? '',
            'title': item['nama_hewan'] ?? '',
            'price': '${item['harga'] ?? '0.00'}',
            'deskripsi': item['deskripsi'] ?? 'Tidak ada deskripsi',
            'stock': 55,
            'image': '${item['gambar'] ?? 'default.jpg'}',
          };
        }).toList();

        // Initially, show all products
        filteredProducts = List.from(products);

        // Filter products initially based on searchKeyword
        filterProducts(widget.searchKeyword);
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void filterProducts(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        // If search keyword is empty, show all products
        filteredProducts = List.from(products);
      } else {
        // Filter products based on search keyword
        filteredProducts = products.where((product) =>
            product['title'].toLowerCase().contains(keyword.toLowerCase())).toList();
      }
    });
  }

  @override
  void didUpdateWidget(covariant BerandaPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle changes in searchKeyword
    if (widget.searchKeyword != oldWidget.searchKeyword) {
      filterProducts(widget.searchKeyword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.width / 2 - 24,
            flexibleSpace: GestureDetector(
              onHorizontalDragUpdate: (details) {
                // Handle horizontal drag update here
              },
              child: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/banner.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Removed search bar from here
                // Card for categories and grooming features
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Category feature
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KategoriPage(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Icon(Icons.category),
                              SizedBox(height: 8),
                              Text('Categories'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 0.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailProduk(
                          product: filteredProducts[index], // Pass filtered product
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              filteredProducts[index]['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredProducts[index]['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Rp${filteredProducts[index]['price']}",
                                style: TextStyle(
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: filteredProducts.length,
            ),
          ),
        ],
      ),
    );
  }
}
