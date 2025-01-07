import 'package:flutter/material.dart';
import 'package:tubes_ppb/component/appbar.dart';
import 'package:tubes_ppb/api/api_keranjang.dart';
import 'Data.dart' as data;

final List<Map<String, dynamic>> colorpalete = [
  {"green": const Color.fromARGB(255, 101, 136, 100)}
];
final List<Map<String, dynamic>> listdata = [
  {"asd": "asd"}
];

void sortcart() {
  // Salin `listcart` ke `sortedcart`
  data.sortedcart = List<Map<String, dynamic>>.from(data.listcart);

  // Urutkan `sortedcart` berdasarkan `id_penjual`
  data.sortedcart.sort((a, b) => a["id_penjual"].compareTo(b["id_penjual"]));
}

class cart extends StatelessWidget {
  const cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Cartpage(title: "KERANJANG");
  }
}

class Cartpage extends StatefulWidget {
  const Cartpage({super.key, required this.title});
  final String title;
  @override
  State<Cartpage> createState() => _cartpagestate();
}

class _cartpagestate extends State<Cartpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarUMKMku(titleText: 'Keranjang'),
      body: FutureBuilder(
        future: keranjangpembeli(1),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final data = snapshot.data!;
          return Column(
            children: [
              if (data.isEmpty)
                Expanded(
                    child: Center(
                  child: Text(
                    "Keranjang Kosong",
                    textAlign: TextAlign.center,
                  ),
                ))
              else
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = data[index];
                        return Card(
                          child: GestureDetector(
                              // Tambahkan padding ke dalam Card
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  item["Produk"]["image_url"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item["Produk"]["nama_barang"]}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Varian: ini mungkin Varian produk',
                                      style: TextStyle(fontSize: 14),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Text('RP.${item["Produk"]["harga"]}'),
                                    Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              // if (data.listcart[index]["qty"] >
                                              //     1) {
                                              //   setState(() {
                                              //     data.listcart[index]["qty"] -=
                                              //         1;
                                              //   });
                                              // }
                                            },
                                            child: Icon(Icons.remove)),
                                        Text('QTY: ${item["kuantitas"]}'),
                                        TextButton(
                                            onPressed: () {
                                              // setState(() {
                                              //   data.listcart[index]["qty"] +=
                                              //       1;
                                              // });
                                            },
                                            child: Icon(Icons.add)),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                        );
                      }),
                ),
            ],
          );
        },
      ),
    );
  }
}
