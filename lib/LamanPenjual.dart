import 'package:flutter/material.dart';
import 'package:tubes_ppb/BarangPenjual.dart';
import 'Data.dart' as data;

final List<Map<String, dynamic>> colorpalete = [
  {"green": const Color.fromARGB(255, 101, 136, 100)}
];
final List<Map<String, dynamic>> listdata = [
  {
    "nama":
        "Fantech ATOM PRO SERIES Wireless Keyboard Mechanical Gaming Hotswap",
    "harga": "RP.300.000",
    "deskripsi":
        "3 Form Factor to Choose Stellar Edition merupakan seri keyboard gaming mechanical ATOM PRO yang terdiri dari tiga produk dengan layout yang berbeda-beda. ATOM PRO63 MK912 dengan layout 60% ATOM PRO83 MK913 dengan layout 75% ATOM PRO96 MK914 dengan layout 95%. (Coming Soon)"
  }
];

class MyApp extends StatelessWidget {
  const MyApp({super.key, required Map<String, dynamic> product});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'INI LAMAN PENJUAL'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: data.colorpalete[0]["green"],
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.arrow_back_ios_new)),
        title: Text(widget.title),
      ),
      body: SafeArea(
          child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 kotak dalam satu baris
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 4, // Rasio lebar-tinggi dari tiap item
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
                    builder: (context) => MyApp(product: item),
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
                          : Icon(Icons.image,
                              size: 100), // Placeholder jika img kosong
                    ),
                    SizedBox(height: 8),
                    // Nama produk
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item['nama'],
                        style: TextStyle(
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
                        style: TextStyle(
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
