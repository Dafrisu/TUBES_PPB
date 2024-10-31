import 'package:flutter/material.dart';
import 'package:tubes_ppb/BarangPenjual.dart';
import 'Data.dart' as data;
import 'cart.dart';

void main() {
  runApp(Penjual());
}

class Penjual extends StatelessWidget {
  const Penjual({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PagePenjual(title: 'INI LAMAN PENJUAL'),
    );
  }
}

class PagePenjual extends StatefulWidget {
  const PagePenjual({super.key, required this.title});
  final String title;
  @override
  State<PagePenjual> createState() => _PagePenjualState();
}

class _PagePenjualState extends State<PagePenjual> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: data.colorpalete[0]["green"],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => cart()));
            },
            icon: Icon(Icons.shopping_cart),
          )
        ],
        title: Text(widget.title),
      ),
      body: SafeArea(
          child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 kotak dalam satu baris
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 4, // Rasio lebar/tinggi dari tiap item
        ),
        itemCount: data.listdata.length,
        itemBuilder: (context, index) {
          final item = data.listdata[index];
          return InkWell(
              onTap: () {
                // Mengarahkan ke halaman detail produk
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageBarang(product: item),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar produk
                    Expanded(
                      child: item['img'] != ''
                          ? Image.network(
                              item['img'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 100,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.image_not_supported),
                            )
                          : const Icon(Icons.image,
                              size: 100), // Placeholder jika img kosong
                    ),
                    SizedBox(height: 8),
                    // Nama produk
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item['nama'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4),
                    // Harga produk
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item['harga'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        },
      )),
    );
  }
}
